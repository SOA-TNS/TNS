# frozen_string_literal: true

module GoogleTrend
  module Gt
    class StockNewsMapper
      def initialize(data_id, start_date, end_date, gateway_class = Gt::StockApi)
        @data_id = data_id
        @gateway_class = gateway_class
        @start_date = start_date
        @end_date = end_date
        @gateway = @gateway_class.new('TaiwanStockNews', @data_id, @start_date = Time.now.to_s[0..9],
                                      @end_date = Time.now.to_s[0..9])
      end

      def find
        stock = @gateway.jason
        build_entity(stock)
      end

      def build_entity(stock)
        DataMapper.new(stock).build_entity
      end

      class DataMapper
        def initialize(stock)
          @stock = stock
        end

        def build_entity
          GoogleTrend::Entity::StoctNewsEntity.new(
            id: nil,
            date:,
            stock_name:,
            link:,
            source:,
            title:
          )
        end

        def stock_name
          @stock['data'][0]['stock_id']
        end

        def date
          date = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| date << value['date'] } # array
          date.to_s
        end

        def link
          link = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| link << value['link'] } # array
          link.to_s
        end

        def source
          source = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| source << value['source'] } # array
          source.to_s
        end

        def title
          title = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| title << value['title'] } # array
          title.to_s
        end
      end
    end
  end
end
