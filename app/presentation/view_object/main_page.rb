# frozen_string_literal: true

require_relative 'stock'

module Views
  class MainPageInfo
    def initialize(data_recoed, stock, index = nil)
      @data_recoed = Stock.new(data_recoed)
      @stock = stock
      @index = index
    end

    def query
      @stock.query
    end

    def risk
      @stock.risk
    end

    def interest_over_time
      @stock.interest_over_time
    end
  end
end
