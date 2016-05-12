require 'availity_client/coverage'
require 'faraday'
require 'json'

module AvailityClient
  BASE_URL = "https://api.availity.com/#{"demo/" unless ENV['RACK_ENV'] == 'production'}v1/"

  class MissingApiKeyError < StandardError; end

  def self.issue_request(method, url, params)
    api_key = ENV['AVAILITY_API_KEY']
    raise MissingApiKeyError, "AVAILITY_API_KEY Env Var must be set" unless api_key

    uri = URI.parse(url)
    conn = Faraday.new(url: uri) do |faraday|
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.send(method.to_sym) do |req|
      req.headers['x-api-key'] = api_key

      if params.any?
        params.first.each { |key, value| req.params[key.to_s] = value }
      end
    end

    {
      status: response.status,
      body: JSON.parse(response.body)
    }
  end
end
