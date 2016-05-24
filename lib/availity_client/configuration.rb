module AvailityClient
  class Configuration
    # This resource represents the input validation rules for another resource
    class << self
      def get(args={})
        url = "#{AvailityClient.base_url}configurations"
        AvailityClient.issue_request('get', url, args)
      end
    end
  end
end
