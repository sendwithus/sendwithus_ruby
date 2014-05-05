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

    def post(endpoint, payload)
      request(Net::HTTP::Post, request_path(endpoint), payload)
    end

    def get(endpoint)
      request(Net::HTTP::Get, request_path(endpoint))
    end

    private

      def request_path(end_point)
        "/api/v#{@configuration.api_version}/#{end_point}"
      end

      def use_ssl?
        @configuration.protocol == 'https'
      end

      def request(method_klass, path, payload=nil)
        request = method_klass.new(path, initheader = {'Content-Type' =>'application/json'})
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
        when Net::HTTPSuccess
          puts @response.body if @configuration.debug
          @response
        else
          raise SendWithUs::ApiUnknownError, 'An unknown error has occurred'
        end
      rescue Errno::ECONNREFUSED
        raise SendWithUs::ApiConnectionRefused, 'The connection was refused'
      end
  end
end
