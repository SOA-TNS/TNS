# frozen_string_literal: true

module GoogleTrend
  module Mapper
    class DataPreprocessing
      def initialize(entity_class = GoogleTrend::Entity::RgtEntity)
        @entity_class = entity_class
      end

      def query
        @entity_class.query
      end

      def extracted_value
        time_series = @entity_class.time_series
        time_series = time_series.split("\"")
        time_series.select!{|str| str.length >= 20}
        time_series.map!{|element| element[-3..-1].to_f}
        time_series.reverse()
      end

      def interest_over_time
        array = []
        time_series = @entity_class.time_series
        time_series = time_series.split("\"")
        time_series.select!{|str| str.length >= 20}
        time_series.reverse()
        time_series.map!{|str| str.split("=>")}
        time_series.each do |arr|
          hash = {}
          hash['time'] = arr[0]
          hash['value'] = arr[1].to_f
          array.append(hash)
        end
        str = array.to_s
        str.gsub!("=>", ":")
        str
      end  

        
      def to_entity
        Entity::MainPageEntity.new(
          query: query(),
          risk: GoogleTrend::Value::Strategy.new(extracted_value()).at_risk?,
          interest_over_time: interest_over_time()
        )
      end
    end
  end
end
