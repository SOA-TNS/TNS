# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'

describe 'Integration test of ListProjects service and API gateway' do
  it 'must return a list of projects' do
    # GIVEN a project is in the database
    GoogleTrend::Gateway::Api.new(GoogleTrend::App.config)
      .add_stock(STOCK)

    # WHEN we request a list of projects
    list = [STOCK]
    res = GoogleTrend::Service::ListStocks.new.call(list)

    # THEN we should see a single project in the list
    _(res.success?).must_equal true
    list = res.value!
    _(list.stock.count).must_equal 1
    _(list.stock.first.qry).must_equal STOCK
  end

  it 'must return and empty list if we specify none' do
    # WHEN we request a list of projects
    list = []
    res = GoogleTrend::Service::ListProjects.new.call(list)

    # THEN we should see a no projects in the list
    _(res.success?).must_equal true
    list = res.value!
    _(list.stock.count).must_equal 0
  end
end