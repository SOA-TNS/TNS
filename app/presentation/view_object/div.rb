# frozen_string_literal: true

require_relative 'stock'

module Views
  class Div
    def initialize(div)
      @div = div
    end

    attr_reader :div
  end
end
