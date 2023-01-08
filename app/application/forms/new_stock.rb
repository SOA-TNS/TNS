# frozen_string_literal: true

require 'dry-validation'

module GoogleTrend
  module Forms
    class NewStock < Dry::Validation::Contract
      params do
        required(:rgt_url).filled(:string)
      end
    end
  end
end
