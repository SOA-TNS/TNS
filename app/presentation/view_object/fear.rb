# frozen_string_literal: true

require_relative 'stock'

module Views
  class Fear
    def initialize(fear_greed, fear_greed_emotion)
      @fear_greed = fear_greed
      @fear_greed_emotion = fear_greed_emotion
    end

    def fear_greed
      @fear_greed
    end

    def fear_greed_emotion
      @fear_greed_emotion
    end

  end
end