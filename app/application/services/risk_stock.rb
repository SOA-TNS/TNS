# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Analyzes contributions to a project
    class RiskStock
      include Dry::Transaction

      step :validate_stock
      step :retrieve_stock_info
      step :reify_info

      private

      # Steps
      def validate_stock(input)
        if input[:watched_list].include? input[:requested]
          Success(input)
        else
          Failure('Please first request this stock to be added to your list')
        end
      end

      def retrieve_stock_info(input)
        
        input[:response] = Gateway::Api.new(GoogleTrend::App.config).info(input[:requested])

        input[:response].success? ? Success(input) : Failure(input[:response].message)
      rescue StandardError
        Failure('Cannot get stock info right now; please try again later')
      end

      def reify_info(input)
        unless input[:response].processing?
          Representer::StockInfo.new(OpenStruct.new)
          .from_json(input[:response].payload)
          .then { input[:appraised] = _1 }
        end

        Success(input)
      rescue StandardError
        Failure('Error in our info report -- please try again')
      end
    end
  end
end