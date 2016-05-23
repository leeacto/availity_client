require 'availity_client/coverage'
require 'faraday'
require 'json'
require 'uri'
require 'base64'

module AvailityClient
  BASE_URL = "https://api.availity.com/#{"demo/" unless ENV['AVAILITY_API_SECRET'] == 'production'}v1/"

  class MissingApiKeyError < StandardError; end

  class << self
    def premium_key?
      !!ENV['AVAILITY_API_KEY'] && !!ENV['AVAILITY_API_SECRET']
    end

    def generate_token
      base_64_token = Base64.encode64(ENV['AVAILITY_API_KEY'] + ":" + ENV['AVAILITY_API_SECRET']).chomp
      conn = Faraday.new(url: "https://api.availity.com") do |faraday|
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end

      response = conn.post do |req|
        req.url '/v1/token'
        req.headers['Authorization'] = "Basic #{base_64_token}"
        req.body = "grant_type=client_credentials"
      end

      JSON.parse(response.body)['access_token']
    end

    def issue_request(method, url, params)
      api_key = ENV['AVAILITY_API_KEY']
      raise MissingApiKeyError, "AVAILITY_API_KEY Environment Variable must be set" unless api_key

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

      response_body = begin
                        JSON.parse(response.body)
                      rescue JSON::ParserError => e
                        response.body
                      end
      {
        headers: response.headers,
        status: response.status,
        body: response_body
      }
    end
  end
end
