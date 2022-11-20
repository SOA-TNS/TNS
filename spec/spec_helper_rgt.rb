# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start
require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require_relative '../require_app'
require_app

def time_value(file)
  l = []
  a = file['interest_over_time'] # hash
  b = a['timeline_data'] # array
  b.each { |data| l << "#{data['date']} => #{data['values'][0]['value']}" }
  l.to_s
end

RGT_TOKEN = GoogleTrend::App.config.RGT_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/rgt_results.yml'))
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'rgt_api'
