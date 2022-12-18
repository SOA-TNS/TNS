# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

require_relative '../../presentation/view_object/main_page'

module GoogleTrend
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :caching
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets',css: 'bootstrap.css'
    plugin :common_logger, $stderr

    use Rack::MethodOverride

    route do |routing|
      routing.assets
      response['Content-Type'] = 'text/html; charset=utf-8'

      routing.root do
        session[:watching] ||= []
        
        result = Service::ListStocks.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_projects = []
        else
          stocks = result.value!
          if stocks.none?
            flash.now[:notice] = 'Add a Github project to get started'
          end

          session[:watching] = stocks.stocks.map(&:links)
          # viewable_projects = Views::ProjectsList.new(projects)
        end

        view 'home'
      end

      routing.on 'Gtrend' do
        routing.is do
          routing.post do # rubocop:disable Metrics/BlockLength

            stock_made = Service::AddStock.new.call(routing.params)
            
            if stock_made.failure?
              flash[:error] = stock_made.failure
              routing.redirect '/'
            end

            stock = stock_made.value!

            session[:watching].insert(0, stock.query).uniq!

            flash[:notice] = 'Project added to your list'
            routing.redirect "Gtrend/#{stock.query}"
          end
        end

        routing.on String do |qry|
          routing.get do

            session[:watching] ||= []

            result = Service::RiskStock.new.call(
                watched_list: session[:watching],
                requested: qry
            )
            
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end


            # 新增
            appraisal = OpenStruct.new(result.value!)
            if appraisal.response.processing?
              flash[:notice] = 'Project is being cloned and analyzed, ' \
                               'please check back in a moment.'
              routing.redirect '/'
            end
            
            # 舊版
            # stock = result.value!

            stock = appraisal.appraised

            stock_trend = Views::MainPageInfo.new(stock[:data_record], stock[:risk])

            # Only use browser caching in production
            App.configure :production do
              response.expires 60, public: true
            end
            
            view 'Gtrend', locals: { stock_trend: }
          end
        end
      end
    end
  end
end
