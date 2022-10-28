# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module CodePraise
  module Entity
    class RgtEntity < Dry::Struct
      include Dry.Types
  
      attribute :query, Strict::String
      attribute :time_series, Strict::Hash
    end
  end
end
