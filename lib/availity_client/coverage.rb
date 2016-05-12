module AvailityClient
  class Coverage
    class << self
      def get(* args)
        id = args.shift.to_s if args.first.kind_of?(Integer)
        url = "#{AvailityClient::BASE_URL}coverages#{"/" + id if id}"

        AvailityClient.issue_request('get', url, args)
      end
    end
  end
end
