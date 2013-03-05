module SendWithUs

  class Api
    attr_reader :configuration

    # ------------------------------ Class Methods ------------------------------

    def self.configuration
      @configuration ||= SendWithUs::Config.new
    end

    def self.configure
      yield self.configuration if block_given?
    end

    # ------------------------------ Instance Methods ------------------------------

    def initialize(options = {})
      settings = SendWithUs::Api.configuration.settings.merge(options)
      @configuration = SendWithUs::Config.new(settings)
    end

    def send_with(email_name, to, data = {})
      payload = { email_name: email_name, email_to: to, email_data: data }.to_json
      SendWithUs::ApiRequest.new(@configuration).send_with(payload)
    end

  end

end
