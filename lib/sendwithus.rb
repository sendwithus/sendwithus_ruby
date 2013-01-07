require 'net/http'
require 'uri'

module SendWithUs
    VERSION = "0.1"

    class API
        @api_proto = 'http'
        @api_port = '80'
        @api_host = 'api.sendwithus.com'
        @api_version = '0'
        @api_header_key = 'X-SWU-API-KEY'

        attr_accessor :api_key
        attr_accessor :debug

        def initialize(api_key, options = {})
            @api_key = api_key
            @api_proto = options[:api_proto] || @api_proto
            @api_host = options[:api_host] || @api_host
            @api_version = options[:api_version] || @api_version
            @api_port = options[:api_port] || @api_port
        end

        private
        def build_request_path(endpoint)
            path = "#{@api_proto}://#{@api_host}:#{@api_port}/api/v#{@api_version}/#{endpoint}"
            return path
        end

        private
        def api_request(endpoint, options = {})
            uri = URI.parse(build_request_path(endpoint))

            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri)

            request.add_field(@api_header_key, @api_key)
            request.set_form_data(options)

            response = http.request(request)

            return response
        end
        
        public
        def send(email_name, email_to, data = {})
            data[:email_name] = email_name
            data[:email_to] = email_to

            return api_request("send", data)
        end
    end
end

