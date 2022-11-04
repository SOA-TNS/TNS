# frozen_string_literal: true

module CodePraise
  class TwseSingle
    def initialize(stock_data, data_source)
      @stock = stock_data
      @data_source = data_source
    end

    def pd_op
      @stock["PreviousDayOpeningRefPrice"]
    end
    def td_op
      @stock["TodayOpeningRefPrice"]
    end
    def pd_ld
      @stock["PreviousDayLimitDown"]
    end
    def td_ld
      @stock["TodayLimitDown"]
    end
    def pd_lu
      @stock["PreviousDayLimitUp"]
    end
    def td_lu
      @stock["TodayLimitUp"]
    end
  end
end