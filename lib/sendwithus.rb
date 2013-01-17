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
    
    def request_path(end_point)
      "/api/v#{@api_version}/#{end_point}"
    end

    ##
    # used to send the actual http request
    # ignores response and sends synchronously atm
    
    def api_request(end_point, options = {})

      http = Net::HTTP.new(@base_url.host, @base_url.port)
      http.use_ssl = (@base_url.scheme == 'https')
      request = Net::HTTP::Post.new(request_path(end_point))
      request.add_field('X-SWU-API-KEY', @api_key)
      request.set_form_data(options)

      response = http.request(request)
      case response
      when Net::HTTPNotFound
        raise "Invalid API end point: #{end_point} (#{request_path(end_point)})"
      when Net::HTTPSuccess
        # TODO: do something intelligent with response.body
        return response
      else
        raise "Unknown error!"
      end

    rescue Errno::ECONNREFUSED
      raise "Could not connect to #{@base_url.host}!"  
    end
  end
end

