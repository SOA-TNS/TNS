# frozen_string_literal: true
require 'yaml'
require 'google_search_results'
require 'http'

module GoogleTrend
  module Gt
  # access google trend
    class RgtApi
      API_PROJECT_ROOT = 'https://serpapi.com/search.json?'
      ENGINE = "google_trends" #1
      DATA_TYPE = "TIMESERIES" #3

      attr_reader :name
      attr_reader :apikey

      def initialize(apikey, name)
        @name = name #2
        @apikey = apikey #4
      end

      def jason
        Request.new(API_PROJECT_ROOT).rgt(@name, @apikey).parse
      end

      #get data by url
      class Request
        def initialize(resource_root)
          @resource_root = resource_root
        end

        def rgt(name, apikey)
          get("#{@resource_root}engine=#{ENGINE}&q=#{name}&data_type=#{DATA_TYPE}&api_key=#{apikey}")
          # https://serpapi.com/search.json?engine=google_trends&q="TSMC"&data_type="TIMESERIES"&api_key=da4bf99b1c382584e582032bcdb8bc698e024a83c5b9d9f44b1c24dd9d7fcbbc
        end

        def get(url)
          http_response = HTTP.get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end
      # Decorates HTTP responses from FinMind with success/error reporting
      class Response < SimpleDelegator
        
        # Response when get Http status code 401 (Unauthorized)
        Unauthorized = Class.new(StandardError)

        # Response when get Http status code 404 (Not Found)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound,
        }.freeze

        def successful?
          HTTP_ERROR.keys.none?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
