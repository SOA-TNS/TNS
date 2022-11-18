# frozen_string_literal: true

require 'roda'
require 'slim'

module GoogleTrend

  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'bootstrap.css', path: 'app/views/assets'
    plugin :common_logger, $stderr

    
    route do |routing|
        response['Content-Type'] = 'text/html; charset=utf-8'

        routing.root do
            view 'home'
        end

        routing.on 'Gtrend' do
          routing.is do
          
            routing.post do
              rgt_url = routing.params['searchStock']

              trend = GoogleTrend::Gt::TrendMapper.new(rgt_url, App.config.RGT_TOKEN).find
              
              GoogleTrend::Repository::For.entity(trend).create(trend)
              
              routing.redirect "Gtrend/#{rgt_url}"
            end
          end

          routing.on String do |qry|
            # GET /project/owner/project
            routing.get do
              data_record = Repository::For.klass(Entity::RgtEntity).find_stock_name(qry)

              stock =  Mapper::DataPreprocessing.new(data_record).to_entity

              rgt_name = stock.query

              rgt_dic = stock.risk
              view 'Gtrend', locals: { name: rgt_name, interest_over_time: rgt_dic }
            end
          end
        end
    end
  end
end
