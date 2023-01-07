# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Analyzes contributions to a project
    class RiskStock
      include Dry::Transaction

      step :retrieve_stock_info
      step :reify_info

      private

      # Steps
      
      def retrieve_stock_info(input)
        result = Gateway::Api.new(GoogleTrend::App.config).info(input[:requested])
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot get stock info right now; please try again later')
      end

      def reify_info(stock_info_json)
        Representer::StockInfo.new(OpenStruct.new)
          .from_json(stock_info_json)
          .then { |stock_info| Success(stock_info) }
      rescue StandardError
        Failure('Error in our info report -- please try again')

      end

    end
  end
end