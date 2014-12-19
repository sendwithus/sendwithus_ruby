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

    def send_with(email_id, to, data = {}, from = {}, cc = {}, bcc = {}, files = [], esp_account = '', version_name = '', headers = {})

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
      if version_name
        payload[:version_name] = version_name
      end
      if headers
        payload[:headers] = headers
      end

      if files.any?
        payload[:files] = []

        files.each do |file_data|
          if file_data.is_a?(String)
            attachment = SendWithUs::Attachment.new(file_data)
          else
            attachment = SendWithUs::Attachment.new(file_data[:attachment], file_data[:filename])
          end
          payload[:files] << { id: attachment.filename, data: attachment.encoded_data }
        end
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

    def emails()
      SendWithUs::ApiRequest.new(@configuration).get(:emails)
    end

    def render(template_id, version_id = nil, template_data = {})
      payload = {
        template_id: template_id,
        template_data: template_data,
      }
      payload[:version_id] = version_id if version_id
      payload = payload.to_json

      SendWithUs::ApiRequest.new(@configuration).post(:'render', payload)
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

    def list_drip_campaigns()
      SendWithUs::ApiRequest.new(@configuration).get(:drip_campaigns)
    end

    def start_on_drip_campaign(recipient_address, drip_campaign_id, email_data={})

      if email_data.nil?
        payload = {
          recipient_address: recipient_address
        }.to_json
      else
        payload = {
          recipient_address: recipient_address,
          email_data: email_data
        }.to_json
      end

      SendWithUs::ApiRequest.new(@configuration).post("drip_campaigns/#{drip_campaign_id}/activate", payload)
    end

    def remove_from_drip_campaign(recipient_address, drip_campaign_id)
      payload = {
        recipient_address: recipient_address
      }.to_json

      SendWithUs::ApiRequest.new(@configuration).post("drip_campaigns/#{drip_campaign_id}/deactivate", payload)
    end

    def drip_campaign_details(drip_campaign_id)
      SendWithUs::ApiRequest.new(@configuration).get("drip_campaigns/#{drip_campaign_id}")
    end

    def list_customers_on_campaign(drip_campaign_id)
      SendWithUs::ApiRequest.new(@configuration).get("drip_campaigns/#{drip_campaign_id}/customers")
    end

    def list_customers_on_campaign_step(drip_campaign_id, drip_campaign_step_id)
      SendWithUs::ApiRequest.new(@configuration).get("drip_campaigns/#{drip_campaign_id}/step/#{drip_campaign_step_id}/customers")
    end

    # DEPRECATED - use customer_conversion now
    def add_customer_event(customer, event_name, revenue=nil)

      if revenue.nil?
        payload = { event_name: event_name }
      else
        payload = { event_name: event_name, revenue: revenue}
      end

      payload = payload.to_json
      endpoint = 'customers/' + customer + '/conversions'
      SendWithUs::ApiRequest.new(@configuration).post(endpoint, payload)
    end

    def customer_conversion(customer, revenue=nil)
      payload = {}.to_json

      if revenue
        payload = { revenue: revenue }.to_json
      end

      endpoint = "customers/#{customer}/conversions"
      SendWithUs::ApiRequest.new(@configuration).post(endpoint, payload)
    end

    def customer_create(email, data = {})
      payload = {email: email}

      if data.any?
        payload[:data] = data
      end

      payload = payload.to_json
      SendWithUs::ApiRequest.new(@configuration).post("customers", payload)
    end

    def customer_delete(email)
      SendWithUs::ApiRequest.new(@configuration).delete("customers/#{email}")
    end
  end
end
