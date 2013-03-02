module SendWithUs

  class Api
    attr_accessor :api_key

    def initialize(api_key, options = {})
      @api_key = api_key
      @configuration = SendWithUs::Config.new(options.merge( api_key: @api_key ))
    end

    def send_with(email_name, to, data = {})
      payload = { email_name: email_name, email_to: to, email_data: data }.to_json
      SendWithUs::ApiRequest.new(@configuration).send_with(payload)
    end

  end

end
