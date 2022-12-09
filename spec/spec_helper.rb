# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

RGT_TOKEN = GoogleTrend::App.config.RGT_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/rgt_results.yml'))