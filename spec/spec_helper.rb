require 'bundler/setup'
require 'pry'
Bundler.setup

require 'availity_client'

RSpec.configure do |config|
  config.warnings = true
  config.order = :random
end

include AvailityClient
