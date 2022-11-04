# frozen_string_literal: true

require 'http'
require_relative 'TwseSingle'
require_relative 'TwseRank'

module CodePraise
  class TwseApi
    API_PROJECT_ROOT = 'https://openapi.twse.com.tw/v1/'
    # https://openapi.twse.com.tw/v1/exchangeReport/TWT84U -> 以字典為元素組成之一維陣列
    # https://openapi.twse.com.tw/v1/exchangeReport/MI_INDEX20 
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end
    
    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def twse_single(stock_symbol)
      project_req_url = twse_api_path('exchangeReport/TWT84U')
      stock_data = call_twse_url(project_req_url).parse # 回傳的result是json，parse後是hash or array
      stock_data = stock_data.select { |x| x['Code'] == "#{stock_symbol}" }
      stock_data = stock_data[0]
      TwseSingle.new(stock_data, self)
    end

    def twse_rank
      project_req_url = twse_api_path('exchangeReport/MI_INDEX20')
      rank_data = call_twse_url(project_req_url).parse # 回傳的result是json，parse後是hash or array
      TwseRank.new(rank_data, self)
    end
    private

    def twse_api_path(para)
      "#{API_PROJECT_ROOT}#{para}" 
    end

    def call_twse_url(url)
      result = HTTP.get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end
    # result

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end


=begin
# 其他 (以下是在terminal call request的方式)
即時資訊 (回傳不是json)
http GET "https://mis.twse.com.tw/stock/api/getStockInfo.jsp?ex_ch=tse_2330.tw&json=1&delay=0"
範圍內資料
http GET "https://query1.finance.yahoo.com/v8/finance/chart/2330.TW?period1=1661961600&period2=1664553600&interval=1d&events=history&=hP2rOschxO0"
=end

# time_num = Time.mktime(2022,10,29).to_i 能回傳2022/10/29的時間戳
# time_exa = Time.at(time_num) 能回傳2022/10/29