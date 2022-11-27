# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  CASSETTE_FILE = 'rgt_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
      c.ignore_localhost = true # for acceptance tests
    end
  end

  def self.configure_vcr_for_google_trend
    VCR.configure do |c|
      c.filter_sensitive_data('<RGT_TOKEN>') { RGT_TOKEN }
    end

    VCR.insert_cassette(
      CASSETTE_FILE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers],
      allow_playback_repeats: true
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
