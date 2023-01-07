# frozen_string_literal: true

require_relative 'stock'

module Views
  class News
    def initialize(news)
      @news = news
    end

    def news
      @news
    end

  end
end