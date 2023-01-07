# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Finmind
  module Representer
    # Represents a CreditShare value
    class FmFearRepresenter < Roar::Decorator
      include Roar::JSON

      property :time
      property :fear_greed
      property :fear_greed_emotion
    end
  end
end
