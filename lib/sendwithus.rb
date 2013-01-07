require 'net/http'

module SendWithUsAPI
    VERSION = "0.1"

    class API
        self.api_proto = 'https'
        self.api_host = 'api.sendwithus.com'
        self.api_version = '0'

        cattr_accessor :api_key
        cattr_accessor :debug

        def initialize(api_key, options = {})
            @api_key = api_key
            @api_proto = options[:api_proto] || @api_proto
            @api_host = options[:api_host] || @api_host
            @api_version = options[:api_version] || @api_version
        end

        private
        def build_request_path(endpoint)
            path = ""
            return path
        end

        private
        def api_request(endpoint, options = {})
            Net::HTTP.get( 'www.ruby-lang.org', 80 )

        end

        def send(email_name, email_to, data = {})
            Endpoint = 'send'

            data[:email_name] = email_name
            data[:email_to] = email_to

            return self.api_request(Endpoint, data)
        end
    end
end

