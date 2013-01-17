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
    DEFAULT_URL = "http://api.sendwithus.com"

    def initialize(api_key, options = {})
      @api_key = api_key
      default_source = URI.parse(options[:url] || DEFAULT_URL)
      @api_proto = options[:api_proto] || default_source.scheme
      @api_host = options[:api_host] || default_source.host
      @api_version = options[:api_version] || 0
      @api_port = options[:api_port] || default_source.port
      @debug = options[:debug]
      @base_url = URI.parse("#{@api_proto}://#{@api_host}:#{@api_port}/api/v#{@api_version}")
    end

    ##
    # send a templated email!
    
    def send_email(email_name, email_to, data = {})
      data[:email_name] = email_name
      data[:email_to] = email_to
      return api_request("send", data)
    end

    private

    ##
    # used to build the request path
    
    def build_request_path(endpoint)
      
      path = "#{@api_proto}://#{@api_host}:#{@api_port}/api/v#{@api_version}/#{endpoint}"
      return path
    end

    ##
    # used to send the actual http request
    # ignores response and sends synchronously atm
    
    def api_request(endpoint, options = {})
      
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

