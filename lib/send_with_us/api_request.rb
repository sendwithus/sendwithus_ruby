module SendWithUs
  class ApiInvalidEndpoint < StandardError; end
  class ApiConnectionRefused < StandardError; end
  class ApiUnknownError < StandardError; end

  class ApiRequest

    def initialize(configuration)
      @configuration = configuration
    end

    def send_with(payload)
      request       = Net::HTTP::Post.new(request_path(:send), initheader = {'Content-Type' =>'application/json'})
      http          = Net::HTTP.new(@configuration.host, @configuration.port)
      http.use_ssl  = @configuration.protocol == 'https'
      request.body  = payload.to_json
      request.add_field('X-SWU-API-KEY', @configuration.api_key)

      response = http.request(request)

      case response
      when Net::HTTPNotFound then raise SendWithUs::ApiInvalidEndpoint
      when Net::HTTPSuccess
        puts response.body if @configuration.debug
        response
      else raise SendWithUs::ApiUnknownError
      end
    rescue Errno::ECONNREFUSED
      raise SendWithUs::ApiConnectionRefused
    end

    private

      def request_path(end_point)
        "/api/v#{@configuration.api_version}/#{end_point}"
      end

  end
end
