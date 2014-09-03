require "base64"

module SendWithUs
  class ApiNilEmailId < StandardError; end

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

    def send_with(email_id, to, data = {}, from = {}, cc={}, bcc={}, files=[], esp_account='')

      if email_id.nil?
        raise SendWithUs::ApiNilEmailId, 'email_id cannot be nil'
      end

      payload = { email_id: email_id, recipient: to,
        email_data: data }

      if from.any?
        payload[:sender] = from
      end
      if cc.any?
        payload[:cc] = cc
      end
      if bcc.any?
        payload[:bcc] = bcc
      end
      if esp_account
        payload[:esp_account] = esp_account
      end

      files.each do |path|
        file = open(path).read
        id = File.basename(path)
        data = Base64.encode64(file)
        if payload[:files].nil?
          payload[:files] = []
        end
        payload[:files] << {id: id, data: data}
      end

      payload = payload.to_json
      SendWithUs::ApiRequest.new(@configuration).post(:send, payload)
    end

    def drips_unsubscribe(email_address)

      if email_address.nil?
        raise SendWithUs::ApiNilEmailId, 'email_address cannot be nil'
      end

      payload = { email_address: email_address }
      payload = payload.to_json

      SendWithUs::ApiRequest.new(@configuration).post(:'drips/unsubscribe', payload)
    end

    def drip_campaign_activate(campaign_id, email_address, data)

      if email_address.nil?
        raise SendWithUs::ApiNilEmailId, 'email_address cannot be nil'
      end

      if campaign_id.nil?
        raise SendWithUs::ApiBadRequest, 'campaign_id cannot be nil'
      end

      payload = data.merge( recipient_address: email_address )
      payload = payload.to_json

      SendWithUs::ApiRequest.new(@configuration).post("drip_campaigns/#{campaign_id}/activate", payload)
    end

    def drip_campaign_deactivate(campaign_id, email_address)

      if email_address.nil?
        raise SendWithUs::ApiNilEmailId, 'email_address cannot be nil'
      end

      if campaign_id.nil?
        raise SendWithUs::ApiBadRequest, 'campaign_id cannot be nil'
      end

      payload = { recipient_address: email_address }
      payload = payload.to_json

      SendWithUs::ApiRequest.new(@configuration).post("drip_campaigns/#{campaign_id}/deactivate", payload)
    end

    def emails()
      SendWithUs::ApiRequest.new(@configuration).get(:emails)
    end

    def create_template(name, subject, html, text)
      payload = {
        name: name,
        subject: subject,
        html: html,
        text: text
      }.to_json

      SendWithUs::ApiRequest.new(@configuration).post(:emails, payload)
    end

    def add_customer_event(customer, event_name, revenue=nil)
      
      if revenue.nil? 
        payload = { event_name: event_name }
      else
        payload = { event_name: event_name, revenue: revenue}
      end      
      
      payload = payload.to_json
      endpoint = 'customers/' + customer + '/events'
      SendWithUs::ApiRequest.new(@configuration).post(endpoint, payload)
    end    

  end  
end

