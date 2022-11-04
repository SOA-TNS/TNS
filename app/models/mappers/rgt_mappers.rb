# frozen_string_literal: true
require_relative '../entities/rgt_entities'
require_relative '../gateways/rgt_api'

module GoogleTrend
  module Gt
    class TrendMapper
      def initialize(name, gateway_class = Gt::Api)
        @name = name
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@name)
      end

      def get_rgt
        rgt = @gateway.jason
        build_entity(rgt)
      end

      def build_entity(rgt)
        DataMapper.new(rgt).build_entity
      end

      class DataMapper
        def initialize(rgt)
          @rgt = rgt
        end
        def build_entity
          GoogleTrend::Entity::RgtEntity.new(
            query:,
            time_series:
          )
        end
        def query
          @rgt['search_parameters']['q']
        end
        def time_series
          data_hash = {}
          data = @rgt['interest_over_time']['timeline_data'] # array
          data.each{ |x| data_hash[ x['date'] ] = x['values'][0]['extracted_value'] }
          data_hash
        end
      end
    end
  end
end
