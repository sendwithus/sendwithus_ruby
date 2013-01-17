##
# Send With Us Ruby API Client
#
# Copyright sendwithus 2013
# Author: matt@sendwithus.com
# See: http://github.com/sendwithus for more

require 'net/http'
require 'uri'

module SendWithUs

    VERSION = "0.1"

    class API

        ##
        # API object
        #
        # Currently only supports send
        # API instance requires your sendiwthus API_KEY
        
        attr_accessor :api_key

        def initialize(api_key, options = {})
            # requires api_key
            
            @api_key = api_key

            @api_proto = options[:api_proto] || 'http'
            @api_host = options[:api_host] || 'api.sendwithus.com'
            @api_version = options[:api_version] || '0'
            @api_port = options[:api_port] || '80'
            @debug = options[:debug] || false
        end
        def send(email_name, email_to, data = {})
            # send a templated email!
            
            data[:email_name] = email_name
            data[:email_to] = email_to

            return api_request("send", data)
        end

        private
        
        def build_request_path(endpoint)
            # used to build the request path
            
            path = "#{@api_proto}://#{@api_host}:#{@api_port}/api/v#{@api_version}/#{endpoint}"
            puts path
            return path
        end

        def api_request(endpoint, options = {})
            # used to send the actual http request
            # ignores response and sends synchronously atm
            
            uri = URI.parse(build_request_path(endpoint))

            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri)

            request.add_field('X-SWU-API-KEY', @api_key)
            request.set_form_data(options)

            response = http.request(request)

            return response
        end
        

    end
end

