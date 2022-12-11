# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Retrieves array of all listed project entities
    class ListStocks
      include Dry::Transaction

      step :get_api_list
      step :reify_list

      private

      def get_api_list(stocks_list)
        Gateway::Api.new(GoogleTrend::App.config)
          .stocks_list(stocks_list)
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_list(stocks_json)
        Representer::StocksList.new(OpenStruct.new)
          .from_json(stocks_json)
          .then { |stocks| Success(stocks) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end