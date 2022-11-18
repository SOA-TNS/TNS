# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative 'second_page_entity'

module GoogleTrend
  module Entity
    class MainPageEntity < Dry::Struct
      include Dry.Types
  
      attribute :query,     Strict::String
      attribute :risk,      Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
