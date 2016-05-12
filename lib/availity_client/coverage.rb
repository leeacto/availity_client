module AvailityClient
  class Coverage
    class << self
      def get(* args)
        api_key = ENV['AVAILITY_API_KEY']
        raise MissingApiKey, "AVAILITY_API_KEY Env Var must be set" unless api_key

        uri = URI.parse(BASE_URL + "coverages")
        conn = Faraday.new(url: uri) do |faraday|
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end

        response = conn.get do |req|
          req.headers['x-api-key'] = api_key
        end

        {
          status: response.status,
          body: JSON.parse(response.body)
        }
      end
    end
  end
end
