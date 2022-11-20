# frozen_string_literal: true

require_relative 'spec_helper_rgt'
require_relative 'helpers/vcr_helper'

describe 'Tests RGT API library' do
  before do
    VcrHelper.configure_vcr_for_google_trend
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Stock information' do
    before do
      @rgt = GoogleTrend::Gt::TrendMapper
        .new('TSLA', RGT_TOKEN)
        .find
    end

    it 'HAPPY: should provide correct GoogleTrend query' do
      _(@rgt.query).must_equal CORRECT['search_parameters']['q']
    end

    it 'BAD: should raise exception when unauthorized' do
      _(proc do
        GoogleTrend::Gt::TrendMapper
          .new('TSLA', 'BAD_TOKEN')
          .find
      end).must_raise GoogleTrend::Gt::RgtApi::Response::Unauthorized
    end
  end

  describe 'popular values in information' do
    before do
      @rgt = GoogleTrend::Gt::TrendMapper
        .new('TSLA', RGT_TOKEN)
        .find
    end

    it 'HAPPY: should recognize values' do
      _(@rgt).must_be_kind_of GoogleTrend::Entity::RgtEntity
    end

    it 'HAPPY: should identify values' do
      _(@rgt.time_series).wont_be_nil
      _(@rgt.time_series).must_equal time_value(CORRECT)
    end
  end
end
