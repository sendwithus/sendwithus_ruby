module SendWithUs
  class ApiInvalidEndpoint < StandardError; end
  class ApiConnectionRefused < StandardError; end
  class ApiBadRequest < StandardError; end
  class ApiInvalidKey < StandardError; end
  class ApiUnknownError < StandardError; end

  class ApiRequest
    attr_reader :response

    def initialize(configuration)
      @configuration = configuration
    end

    def send_with(payload)
      path          = request_path(:send)
      request       = Net::HTTP::Post.new(path, initheader = {'Content-Type' =>'application/json'})
      request.add_field('X-SWU-API-KEY', @configuration.api_key)
      request.add_field('X-SWU-API-CLIENT', @configuration.client_stub)

      http          = Net::HTTP.new(@configuration.host, @configuration.port)
      http.use_ssl  = use_ssl?
      http.set_debug_output($stdout) if @configuration.debug

      @response = http.request(request, payload)

      case @response
      when Net::HTTPNotFound then
        raise SendWithUs::ApiInvalidEndpoint, path
      when Net::HTTPForbidden then
        raise SendWithUs::ApiInvalidKey, 'Invalid api key: ' + @configuration.api_key
      when Net::HTTPBadRequest then
        raise SendWithUs::ApiBadRequest, @response.body
      when Net::HTTPSuccess then
        puts @response.body if @configuration.debug
        @response
      else
        raise SendWithUs::ApiUnknownError, 'An unknown error has occurred'
      end
    rescue Errno::ECONNREFUSED
      raise SendWithUs::ApiConnectionRefused, 'The connection was refused'
    end

    def get(endpoint)
      path = request_path(endpoint)
      request = Net::HTTP::Get.new(path, initheader = {'Content-Type' =>'application/json'})
      request.add_field('X-SWU-API-KEY', @configuration.api_key)
      request.add_field('X-SWU-API-CLIENT', @configuration.client_stub)

      http          = Net::HTTP.new(@configuration.host, @configuration.port)
      http.use_ssl  = use_ssl?
      http.set_debug_output($stdout) if @configuration.debug

      @response = http.request(request)

      case @response
      when Net::HTTPNotFound then
        raise SendWithUs::ApiInvalidEndpoint, path
      when Net::HTTPForbidden then
        raise SendWithUs::ApiInvalidKey, 'Invalid api key: ' + @configuration.api_key
      when Net::HTTPBadRequest then
        raise SendWithUs::ApiBadRequest, @response.body
      when Net::HTTPSuccess
        puts @response.body if @configuration.debug
        @response
      else
        raise SendWithUs::ApiUnknownError, 'An unknown error has occurred'
      end
    rescue Errno::ECONNREFUSED
      raise SendWithUs::ApiConnectionRefused, 'The connection was refused'
    end

    private

      def request_path(end_point)
        "/api/v#{@configuration.api_version}/#{end_point}"
      end

      def use_ssl?
        @configuration.protocol == 'https'
      end

  end
end
