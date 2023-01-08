# frozen_string_literal: true

require_relative 'stock'

module Views
  class Buysell
    def initialize(buy)
      @buy = buy
    end

    attr_reader :buy
  end
end
