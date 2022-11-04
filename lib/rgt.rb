# frozen_string_literal: true

module GoogleTrend
  # get data
  class RgtData
    def initialize(rgt_data, rgt_source)
      @rgt = rgt_data
      @rgt_source = rgt_source
    end

    attr_reader :rgt
  end
end
