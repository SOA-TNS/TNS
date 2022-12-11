# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'

describe 'Unit test of GoogleTrend API gateway' do
  it 'must report alive status' do
    alive = GoogleTrend::Gateway::Api.new(GoogleTrend::App.config).alive?
    _(alive).must_equal true
  end

  it 'must be able to add a stock' do
    res = GoogleTrend::Gateway::Api.new(GoogleTrend::App.config)
      .add_stock(STOCK)

    _(res.success?).must_equal true
  end

  it 'must return a list of stocks' do
    # GIVEN a stock is in the database
    GoogleTrend::Gateway::Api.new(GoogleTrend::App.config)
      .add_stock(STOCK)

    # WHEN we request a list of stocks
    list = [STOCK]
    res = GoogleTrend::Gateway::Api.new(GoogleTrend::App.config)
      .stocks_list(list)

    # THEN we should see a single stock in the list
    _(res.success?).must_equal true
  end

  it 'must return a stock appraisal' do
    # GIVEN a stock is in the database
    GoogleTrend::Gateway::Api.new(GoogleTrend::App.config)
      .add_stock(STOCK)

    # WHEN we request an appraisal
    req = OpenStruct.new(
        query: STOCK
      )

    res = GoogleTrend::Gateway::Api.new(GoogleTrend::App.config)
      .info(req)

    # THEN we should see a single stock in the list
    _(res.success?).must_equal true
  end
end