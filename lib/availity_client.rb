require 'net/http'
require 'availity_client/coverage'
require 'faraday'
require 'json'

module AvailityClient
  BASE_URL = "https://api.availity.com/#{"demo/" unless ENV['RACK_ENV'] == 'production'}v1/"

  class MissingApiKey < StandardError; end
end
