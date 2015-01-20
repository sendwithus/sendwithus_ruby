require "base64"

module SendWithUs



  class SendRequest

  end




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

    # DEPRECATED: Please use 'send' instead.
    #
    # Sends the specified email with any arguments.
    #
    # * *Args*    :
    #   - +email_id+ -> ID of the email to send
    #   - +to+ -> Hash of recipient details
    #   - +data+ -> Hash of email data
    #   - +from+ -> Hash of sender details
    #   - +cc+ -> Array of CC recipients
    #   - +bcc+ -> Array of BCC recipients
    #   - +files+ -> Array of attachments
    #   - +esp_account+ -> The ESP account to use
    #   - +version_name+ -> The specific email version to use
    #   - +headers+ -> Hash of headers
    #   - +tags+ -> Array of tags
    #
    def send_with(email_id, to, data = {}, from = {}, cc = [], bcc = [], files = [], esp_account = '', version_name = '', headers = {}, tags = [])
      warn "[DEPRECATED] 'send_with' is deprecated.  Please use 'send' instead."

      send(
        email_id,
        to,
        {
          data: data,
          from: from,
          cc: cc,
          bcc: bcc,
          files: files,
          esp_account: esp_account,
          version_name: version_name,
          headers: headers,
          tags: tags
        }
      )
    end

    # Sends the specified email with any optional arguments
    #
    # * *Args*    :
    #   - +email_id+ -> ID of the email to send
    #   - +to+ -> Hash of recipient details
    # * *Options*    :
    #   - +:data+ -> Hash of email data
    #   - +:from+ -> Hash of sender details
    #   - +:cc+ -> Array of CC recipients
    #   - +:bcc+ -> Array of BCC recipients
    #   - +:files+ -> Array of attachments
    #   - +:esp_account+ -> The ESP account to use
    #   - +:version_name+ -> The specific email version to use
    #   - +:headers+ -> Hash of headers
    #   - +:tags+ -> Array of tags
    #   - +:locale+ -> Localization string
    #
    def send(email_id, to, options = {})
      if email_id.nil?
        raise SendWithUs::ApiNilEmailId, 'email_id cannot be nil'
      end

      payload = {
        email_id: email_id,
        recipient: to
      }

      if not options[:data].nil? and options[:data].any?
        payload[:email_data] = options[:data]
      end
      if not options[:from].nil? and options[:from].any?
        payload[:sender] = options[:from]
      end
      if not options[:cc].nil? and options[:cc].any?
        payload[:cc] = options[:cc]
      end
      if not options[:bcc].nil? and options[:bcc].any?
        payload[:bcc] = options[:bcc]
      end
      if not options[:esp_account].nil?
        payload[:esp_account] = options[:esp_account]
      end
      if not options[:version_name].nil?
        payload[:version_name] = options[:version_name]
      end
      if not options[:headers].nil? and options[:headers].any?
        payload[:headers] = options[:headers]
      end
      if not options[:tags].nil? and options[:tags].any?
        payload[:tags] = options[:tags]
      end
      if not options[:tags].nil? and options[:tags].any?
        payload[:tags] = options[:tags]
      end
      if not options[:locale].nil?
        payload[:locale] = options[:locale]
      end

      if not options[:files].nil? and options[:files].any?
        payload[:files] = []

        options[:files].each do |file_data|
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

    # DEPRECATED: Please use 'customer_conversion' instead.
    def add_customer_event(customer, event_name, revenue=nil)
      warn "[DEPRECATED] 'add_customer_event' is deprecated.  Please use 'customer_conversion' instead."

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
