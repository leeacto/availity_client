module AvailityClient
  class Coverage
    class << self
      def get(* args)
        if args.first.kind_of?(Integer)
          id = args.shift.to_s
        end

        url = "#{AvailityClient.base_url}coverages#{"/" + id if id}"
        AvailityClient.issue_request('get', url, args.first)
      end

      def delete(id)
        url = "#{AvailityClient.base_url}coverages/#{id}"

        AvailityClient.issue_request('delete', url, {})
      end
    end
  end
end
