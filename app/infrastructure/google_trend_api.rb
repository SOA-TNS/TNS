# frozen_string_literal: true

require_relative 'list_request'
require 'http'

module GoogleTrend
  module Gateway
    # Infrastructure to call CodePraise API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def stocks_list(list)
        @request.stocks_list(list)
      end

      def add_stock(qry)
        @request.add_stock(qry)
      end

      def info(req)
        @request.get_info(req)
      end

      def fear(qry)
        @request.get_fear(qry)
      end

      def per(qry)
        @request.get_per(qry)
      end

      def div(qry)
        @request.get_div(qry)
      end

      def buysell(qry)
        @request.get_buysell(qry)
      end

      def news(qry)
        @request.get_news(qry)
      end

      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def stocks_list(list)
          call_api('get', ['Gtrend'], 'list' => Value::WatchedList.to_encoded(list))
        end

        def add_stock(qry)
          call_api('post', ['Gtrend', qry])
        end

        def get_info(qry)
          call_api('post', ['Risk', qry])
        end

        def get_fear(qry)
          call_api('post', ['Fear',qry])
        end

        def get_per(qry)
          call_api('post', ['Per',qry])
        end

        def get_div(qry)
          call_api('post', ['Div',qry])
        end
        
        def get_buysell(qry)
          call_api('post', ['BuySell',qry])
        end

        def get_news(qry)
          call_api('get', ['News',qry])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299).freeze

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def message
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end