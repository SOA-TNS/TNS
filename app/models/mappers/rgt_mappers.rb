# frozen_string_literal: true


module GoogleTrend
  module Gt
    class TrendMapper

      def initialize(name,apikey, gateway_class = Gt::RgtApi)
        @apikey = apikey
        @name = name
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@config, @name)
      end

      def find
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
            id: nil,
            query:,
            time_series:
          )
        end
        def query
          @rgt['search_parameters']['q']
        end
        def time_series
          array = []
          interest_over_time = @rgt["interest_over_time"] #hash
          time_series = interest_over_time["timeline_data"] #array
          time_series.each{ |data| array << "#{data["date"]} => #{data["values"][0]["value"]}"  }
          array.to_s
        end
      end
    end
  end
end
