module SendWithUs

  class Api

    def initialize(options = {})
      @configuration = SendWithUs::Config.new(options)
    end

    def send_with(email_name, to, data = {})
      payload = { email_name: email_name, email_to: to, email_data: data }.to_json
      SendWithUs::ApiRequest.new(@configuration).send_with(payload)
    end

  end

end
