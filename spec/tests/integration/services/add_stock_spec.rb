# frozen_string_literal: true

require_relative '../../../helpers/spec_helper_rgt'

describe 'Integration test of AddProject service and API gateway' do
  it 'must add a legitimate project' do
    # WHEN we request to add a project

    res = GoogleTrend::Service::AddStock.new.call(QUERY)

    # THEN we should see a single project in the list
    _(res.success?).must_equal true
    stock = res.value!
    _(stock.query).must_equal STOCK
  end
end