# frozen_string_literal: true

require 'rubygems'
require 'json'
require 'pp'

module GoogleTrend
  module Value
    class StockOverview
      def initialize(stock_name)
        @stock_name = stock_name
      end

      def stock_overview
        json = File.read('stock.json')
        obj = JSON.parse(json)
        obj[@stock_name]
      end
    end
  end
end
