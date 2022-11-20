# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module GoogleTrend
  module Entity
    class SecondPageEntity < Dry::Struct
      include Dry.Types

      attribute :stock_name, Strict::String
      # attribute :prices, GoogleTrend::Value::Detail

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
