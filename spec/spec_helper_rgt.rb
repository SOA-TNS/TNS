# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require_relative '../lib/rgt_api'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
RGT_TOKEN = CONFIG['api_key']
CORRECT = YAML.safe_load(File.read('spec/fixtures/rgt_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'rgt_api'
