require 'http'
require 'yaml'


def twse_api_path(path)
  "https://openapi.twse.com.tw/v1/#{path}"
end

def call_twse_url(url)
  HTTP.get(url)
end

twse_response = {} # 存每個api request回傳的結果(json)
twse_results = {} # 存parse後結果(hash)中的各細項資料

request_url_1 = twse_api_path('exchangeReport/TWT84U')
twse_response[request_url_1] = call_twse_url(request_url_1)
twse_results['上市個股股價升降幅度'] = twse_response[request_url_1].parse

request_url_2 = twse_api_path('exchangeReport/MI_INDEX20')
twse_response[request_url_2] = call_twse_url(request_url_2)
twse_results['集中市場每日成交量前二十名證券'] = twse_response[request_url_2].parse

File.write('twse_results.yml', twse_results.to_yaml)

