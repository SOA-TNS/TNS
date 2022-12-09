# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require_relative '../../require_app'
require_app

def time_value(file)
  array = []
  time_series = file['interest_over_time'] # hash
  interest_over_time = interest_over_time['timeline_data'] # array
  interest_over_time.each { |data| array << "#{data['date']} => #{data['values'][0]['value']}" }
  array.to_s
end

RGT_TOKEN = GoogleTrend::App.config.RGT_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/rgt_results.yml'))

# Helper method for acceptance tests
def homepage
  GoogleTrend::App.config.APP_HOST
end