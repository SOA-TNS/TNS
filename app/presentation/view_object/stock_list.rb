# frozen_string_literal: true

require_relative 'stock'

module Views
  # View for a a list of project entities
  class StocksList
    def initialize(data_recoed)
      @data_recoed = data_recoed.map.with_index { |stock, i| Stock.new(stock, i) }
    end

    def each(&)
      @data_recoed.each(&)
    end

    def any?
      @data_recoed.any?
    end
  end
end
