# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests FinMind API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
  end

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes, match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  stocks = FinMindAPI::FinMindApi.new
  stocks.dataset('TaiwanStockInfo')

  describe 'Status' do
    it 'stock_dataset' do
      _(stocks.finMind.get_stock['status']).must_equal CORRECT['status']
    end
  end

  describe 'Msg' do
    it 'stock_dataset' do
      _(stocks.finMind.get_stock['msg']).must_equal CORRECT['msg']
    end
  end
end
