# frozen_string_literal: true

require_relative '../mappers/data_preprocessing'
module GoogleTrend
  module Value
    class Strategy
    
      def initialize(extracted_value)
        @extracted_value = extracted_value
      end
      
      def MA
        sum_3 = 0
        sum_18 =0
        3.times do |i|
          sum_3 += @extracted_value[i]
        end
        
        18.times do |i|
          sum_18 += @extracted_value[i]
        end0
        return sum_3/3, sum_18/18
      end



      def at_risk?
        ma = MA()
        risk = ((ma[1] > ma[0]) or @extracted_value[0] < 80) ? "not at risk" : "at risk"
        risk
      end
    end
  end
end
