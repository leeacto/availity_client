module AvailityClient
  class Coverage
    class << self
      def get(* args)
        id = args.shift.to_s if args.first.kind_of?(Integer)
        url = "#{AvailityClient::BASE_URL}coverages#{"/" + id if id}"

        AvailityClient.issue_request('get', url, args)
      end

      def delete(id)
        url = "#{AvailityClient::BASE_URL}coverages/#{id}"

        AvailityClient.issue_request('delete', url, {})
      end
    end
  end
end
