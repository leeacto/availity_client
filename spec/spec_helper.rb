require 'bundler/setup'
require 'pry'
require 'availity_client'
Bundler.setup

RSpec.configure do |config|
  config.warnings = true
  config.order = :random
end

include AvailityClient
