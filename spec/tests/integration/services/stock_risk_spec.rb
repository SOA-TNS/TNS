# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'

describe 'Integration test of RiskStock service and API gateway' do
  it 'must get the info of an existing stock' do
    req = OpenStruct.new(
        query: STOCK
      )
    
    watched_list = [req.query]
    # WHEN we request to add a project
    res = GoogleTrend::Service::RiskStock.new.call(
      watched_list: watched_list,
      requested: STOCK
  )

    # THEN we should see a single stock in the list
    _(res.success?).must_equal true
    info = res.value!
    _(info.data_record.query).must_equal STOCK
  end
end