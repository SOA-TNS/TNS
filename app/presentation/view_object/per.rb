# frozen_string_literal: true

require_relative 'stock'

module Views
  class Per
    def initialize(per)
      @per = per
    end

    attr_reader :per
  end
end
