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
    # plugin :caching
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/assets/css'
    plugin :assets, path: 'app/presentation/assets',
                    css: ['Home.css','nicepage.css','Page-2.css','Page-3.css'],js: ['jquery.js','nicepage.js','chart.js','echarts.js']
    plugin :common_logger, $stderr

    use Rack::MethodOverride

    route do |routing|
      routing.assets
      routing.public
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.root do
        routing.assets
        routing.public
        session[:watching] ||= []
        fm_fear = Service::FmFear.new.call().value!
        fm_fear_view = Views::Fear.new(fm_fear[:fear_greed], fm_fear[:fear_greed_emotion])
        view 'HOME', locals: { fm_fear_view: }
      end

      routing.on 'Gtrend' do
        routing.assets
        routing.public
        routing.is do
          routing.post do # rubocop:disable Metrics/BlockLength
            stock_made = Service::AddStock.new.call(routing.params)

            if stock_made.failure?
              flash[:error] = stock_made.failure
              routing.redirect '/'
            end

            stock = stock_made.value!

            session[:watching].insert(0, stock.query).uniq!

            flash[:notice] = 'stock added to your database'
            routing.redirect "Gtrend/#{stock.query}"
          end
        end

        routing.on String do |qry|
          routing.assets
          routing.public
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

            stock = result.value!
            stock_trend = Views::MainPageInfo.new(stock[:data_record], stock[:risk])

            fm_per = Service::FmPer.new.call(qry).value!
            fm_per_view = Views::Per.new(fm_per[:per])

            fm_buysell = Service::FmBuysell.new.call(qry).value!
            fm_buy_view = Views::Buysell.new(fm_buysell[:buy])

            fm_div = Service::FmDiv.new.call(qry).value!
            fm_div_view = Views::Div.new(fm_div[:div_yield])

            view 'PAGE', locals: { qry: ,stock_trend: ,fm_per_view: ,fm_buy_view: ,fm_div_view: }
          end
        end
      end
      routing.on 'Per' do
        routing.on String do |qry|
          routing.post do # rubocop:disable Metrics/BlockLength
            fm_per = Service::FmPer.new.call(qry).value!
            fm_per_view = Views::Per.new(fm_per[:per])
          end
        end
      end
      routing.on 'BuySell' do
        routing.on String do |qry|
          routing.post do # rubocop:disable Metrics/BlockLength
            fm_buysell = Service::FmBuysell.new.call(qry).value!
            fm_buy_view = Views::Buysell.new(fm_buysell[:buy])
          end
        end
      end
      routing.on 'Div' do
        routing.on String do |qry|
          routing.post do # rubocop:disable Metrics/BlockLength
            fm_div = Service::FmDiv.new.call(qry).value!
            fm_div_view = Views::Div.new(fm_div[:div_yield])
          end
        end
      end
      routing.on 'Risk' do
        routing.on String do |qry|
          routing.post do # rubocop:disable Metrics/BlockLength
            session[:watching] ||= []

            result = Service::RiskStock.new.call(
                watched_list: session[:watching],
                requested: qry
            )
            
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end
            
            stock = result.value!
            stock_trend = Views::MainPageInfo.new(stock[:data_record], stock[:risk])
          end
        end
      end
      routing.on 'News' do
        routing.assets
        routing.public
        routing.on String do |qry|
          routing.get do # rubocop:disable Metrics/BlockLength
            session[:watching] ||= []

            fm_news = Service::FmNews.new.call(qry).value!
            fm_news_view = Views::News.new(fm_news)
            view 'PAGE3', locals: { qry: ,fm_news_view: }
          end
        end
      end
    end
  end
end
