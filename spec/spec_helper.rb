require 'rubygems'
require 'bundler/setup'
require 'dummy/config/environment' # dummy app
require 'jibe' # this gem
require 'dotenv'
require "pry"
require 'awesome_print'
require 'database_cleaner'

Dotenv.load

Dir["./spec/steps/**/*steps.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = "random"

  # Clean DB
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
