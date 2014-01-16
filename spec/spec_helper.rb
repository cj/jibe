require 'rubygems'
require 'bundler/setup'
require 'jibe' # this gem
require 'dotenv'
require "pry"
require 'awesome_print'
require 'helpers'

Dotenv.load

Dir["./spec/steps/**/*steps.rb"].each { |f| require f }

RSpec.configure do |config|
  # config?
end
