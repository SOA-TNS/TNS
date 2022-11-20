# frozen_string_literal: true

require_relative 'spec_helper_rgt'

describe 'Tests rgt API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.filter_sensitive_data('<RGT_TOKEN>') { RGT_TOKEN }
  end
  config = YAML.safe_load(File.read('config/secrets.yml'))
  search = GoogleTrend::RgtApi.new(config, 'TSMC')

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes, match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'search_metadata' do
    it 'search_metadata' do
      _(search.jason['search_metadata']).must_equal CORRECT['search_metadata']
    end
  end
  describe 'search_parameters' do
    it 'search_parameters' do
      _(search.jason['search_parameters']).must_equal CORRECT['search_parameters']
    end
  end
  describe 'interest_over_time' do
    it 'interest_over_time' do
      _(search.jason['interest_over_time']).must_equal CORRECT['interest_over_time']
    end
  end
end
