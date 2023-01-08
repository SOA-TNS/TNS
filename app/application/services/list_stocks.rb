# frozen_string_literal: true

require 'dry/monads'

module GoogleTrend
  module Service
    # Retrieves array of all listed project entities
    class ListStocks
      include Dry::Monads::Result::Mixin

      def call(stocks_list)
        stocks = Repository::For.klass(Entity::RgtEntity)
          .find_stock_names(stocks_list)

        Success(stocks)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
