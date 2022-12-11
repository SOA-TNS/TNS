# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'main_representer'
require_relative 'rgt_representer'

module GoogleTrend
  module Representer
    class StockInfo < Roar::Decorator
      include Roar::JSON

      property :data_record, extend: Representer::RgtRepresenter, class: OpenStruct
      property :risk, extend: Representer::MainRepresenter, class: OpenStruct
    end
  end
end
