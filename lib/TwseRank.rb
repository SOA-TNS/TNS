# frozen_string_literal: true

module CodePraise
  class TwseRank
    def initialize(rank_data, data_source)
      @rank = rank_data
      @data_source = data_source
    end
    def info(num)
      @rank = @rank.select { |x| x["Rank"].to_i < (num+1) }
      @rank
    end
  end
end
