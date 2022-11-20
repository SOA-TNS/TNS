# frozen_string_literal: true

module Views
  # View for a single project entity
  class Stock
    def initialize(data_recoed, index = nil)
      @data_recoed = data_recoed
      @index = index
    end

    def entity
      @data_recoed
    end

    def query
      @data_record.query
    end

    def time_series
      @data_recoed.time_series
    end
  end
end
