# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Transaction to store project from Github API to database
    class FmDiv
      include Dry::Transaction

      step :request_fear
      step :reify_stock

      private

      def request_fear(input)
          result = Gateway::Api.new(GoogleTrend::App.config).div(CGI.unescape(input))
          result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot find div value right now; please try again later')
      end

      def reify_stock(stock_json)
        Finmind::Representer::FmPerRepresenter.new(OpenStruct.new)
          .from_json(stock_json)
          .then { |stock| Success(stock) }
      rescue StandardError
        Failure('Error in the FindMind -- please try again')
      end
    end
  end
end