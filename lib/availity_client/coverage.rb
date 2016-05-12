module AvailityClient
  class Coverage
    class << self
      def get(* args)
        id = args.shift.to_s if args.first.kind_of?(Integer)
        url = "#{BASE_URL}coverages#{"/" + id if id}" 

        response = AvailityClient.issue_request('get', url, args)

        {
          status: response.status,
          body: JSON.parse(response.body)
        }
      end
    end
  end
end
