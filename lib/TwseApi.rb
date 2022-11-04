# frozen_string_literal: true

require 'http'
require_relative 'TwseSingle'
require_relative 'TwseRank'

module CodePraise
  class TWSEApi
    API_PROJECT_ROOT = 'https://openapi.twse.com.tw/v1/'
    # https://openapi.twse.com.tw/v1/ + exchangeReport/TWT84U
    # https://openapi.twse.com.tw/v1/ + exchangeReport/MI_INDEX20
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end
    
    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def twse_single(stock_symbol)
      project_req_url = gh_api_path('exchangeReport/TWT84U')
      stock_data = call_gh_url(project_req_url).parse # 回傳的result是json，parse後是hash or array
      stock_data = stock_data.select { |x| x['Code'] == "#{stock_symbol}" }
      stock_data = stock_data[0]
      TwseSingle.new(stock_data, self)
    end

    def twse_rank
      project_req_url = gh_api_path('exchangeReport/MI_INDEX20')
      rank_data = call_gh_url(project_req_url).parse # 回傳的result是json，parse後是hash or array
      TwseRank.new(rank_data, self)
    end
    private

    def gh_api_path(para)
      "#{API_PROJECT_ROOT}#{para}" 
    end

    def call_gh_url(url)
      result = HTTP.get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end
    # result

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end

s = CodePraise::TWSEApi.new
s.twse_single(2330).open_price_compare # 印出昨日與今日台積電開盤價比較
puts "-----------------------------"
s.twse_single(2330).limit_compare # 印出昨日與今日台積電漲/跌停價比較
puts "-----------------------------"
s.twse_single(2330).info # 印出昨日與今日台積電主要資訊總覽
puts "-----------------------------"
s.twse_rank.info(5) # 印出成交量前5名證券
