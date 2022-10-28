# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'vcr'
require 'webmock'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/TwseApi.rb'

CORRECT = YAML.safe_load(File.read('../spec/fixtures/twse_results.yml'))
STOCKCODE = 2330
CORRECT_i = CORRECT['上市個股股價升降幅度'].select{ |x| x['Code'] == "#{STOCKCODE}" }
# CORRECT_i 還是 [{}]
CORRECT_i = CORRECT_i[0]
# CORRECT_i 只剩 {}

CASSETTES_FOLDER = '../spec/fixtures/cassettes'
CASSETTE_FILE = 'twse_api'
