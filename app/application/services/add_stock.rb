# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Transaction to store project from Github API to database
    class AddStock
      include Dry::Transaction

      step :request_stock
      step :reify_stock

      private

      def request_stock(input)
        if(GoogleTrend::Value::StockOverview.new(CGI.unescape(input["list"])).stock_overview)
          result = Gateway::Api.new(GoogleTrend::App.config).add_stock(CGI.unescape(input["list"]))
          result.success? ? Success(result.payload) : Failure(result.message)
        else
          Failure("This is not a stock name")
        end
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add projects right now; please try again later')
      end

      def reify_stock(stock_json)
        Representer::RgtRepresenter.new(OpenStruct.new)
          .from_json(stock_json)
          .then { |stock| Success(stock) }
      rescue StandardError
        Failure('Error in the project -- please try again')
      end
    end
  end
end