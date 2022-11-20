# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module GoogleTrend
  module Value
    class Detail < SimpleDelegator
      def initialize(stockname)
        @stockname = stockname
      end

      def openprice; end

      def closeprice; end

      def toplimit; end

      def bottomlimit; end
    end
  end
end
