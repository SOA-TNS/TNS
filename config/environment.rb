# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'sequel'
require 'figaro'
require 'rack/session'

module TravellingSuggestions
  class App < Roda
    plugin :environments
      
    configure do
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config() = Figaro.env
      
      configure :development, :test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end
      use Rack::Session::Cookie, secret: config.SESSION_SECRET
      CWB_TOKEN = config.CWB_TOKEN
      DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
      def self.DB = DB
    end
  end
