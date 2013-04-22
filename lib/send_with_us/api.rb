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

    def send_with(email_id, to, data = {}, from = {})
      if from.any?
        payload = { email_id: email_id, recipient: to, sender: from, email_data: data }.to_json
      else
        payload = { email_id: email_id, recipient: to, email_data: data }.to_json
      end
      SendWithUs::ApiRequest.new(@configuration).send_with(payload)
    end

    def emails()
      SendWithUs::ApiRequest.new(@configuration).get(:emails)
    end

  end

end
