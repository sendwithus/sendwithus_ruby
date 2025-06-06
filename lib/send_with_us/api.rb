require "base64"
require_relative "error"

module SendWithUs
  class ApiNilEmailId < Error; end

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

    # DEPRECATED: Please use 'send_email' instead.
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
    # * *Notes*    :
    #   - "send" is already a ruby-defined method on all classes
    #
    def send_with(email_id, to, data = {}, from = {}, cc = [], bcc = [], files = [], esp_account = '', version_name = '', headers = {}, tags = [])
      warn "[DEPRECATED] 'send_with' is deprecated.  Please use 'send_email' instead."

      send_email(
        email_id,
        to,
        data: data,
        from: from,
        cc: cc,
        bcc: bcc,
        files: files,
        esp_account: esp_account,
        version_name: version_name,
        headers: headers,
        tags: tags
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
    # * *Notes*    :
    #   - "send" is already a ruby-defined method on all classes
    #
    def send_email(email_id, to, options = {})
      if email_id.nil?
        raise SendWithUs::ApiNilEmailId, 'email_id cannot be nil'
      end

      payload = {
        email_id: email_id,
        recipient: to
      }

      if options[:data] && options[:data].any?
        payload[:email_data] = options[:data]
      end
      if options[:from] && options[:from].any?
        payload[:sender] = options[:from]
      end
      if options[:cc] && options[:cc].any?
        payload[:cc] = options[:cc]
      end
      if options[:bcc] && options[:bcc].any?
        payload[:bcc] = options[:bcc]
      end
      if options[:esp_account]
        payload[:esp_account] = options[:esp_account]
      end
      if options[:version_name]
        payload[:version_name] = options[:version_name]
      end
      if options[:headers] && options[:headers].any?
        payload[:headers] = options[:headers]
      end
      if options[:tags] && options[:tags].any?
        payload[:tags] = options[:tags]
      end
      if options[:locale]
        payload[:locale] = options[:locale]
      end

      if options[:files] && options[:files].any?
        payload[:files] = options[:files].map do |file_data|
          SendWithUs::File.new(file_data).to_h
        end
      end

      SendWithUs::ApiRequest.new(@configuration).post(:send, payload.to_json)
    end

    def drips_unsubscribe(email_address)
      if email_address.nil?
        raise SendWithUs::ApiNilEmailId, 'email_address cannot be nil'
      end

      payload = {email_address: email_address}

      payload = payload.to_json
      SendWithUs::ApiRequest.new(@configuration).post(:'drips/unsubscribe', payload)
    end

    def emails()
      SendWithUs::ApiRequest.new(@configuration).get(:emails)
    end

    alias list_templates emails

    def render(template_id, version_id = nil, template_data = {}, strict = false)
      locale = template_data[:locale]

      payload = {
        template: template_id,
        template_data: template_data,
        strict: strict,
      }

      payload[:version_id] = version_id if version_id
      payload[:locale] = locale if locale

      payload = payload.to_json
      SendWithUs::ApiRequest.new(@configuration).post(:'render', payload)
    end

    def create_template(name, subject, html, text, preheader='', amp_html='', template_data={})
      payload = {
        name: name,
        subject: subject,
        html: html,
        text: text,
        preheader: preheader,
        amp_html: amp_html,
        template_data: template_data
      }

      payload = payload.to_json
      SendWithUs::ApiRequest.new(@configuration).post(:emails, payload)
    end

    def list_drip_campaigns()
      SendWithUs::ApiRequest.new(@configuration).get(:drip_campaigns)
    end

    def start_on_drip_campaign(recipient_address, drip_campaign_id, email_data={}, locale=nil, tags=[])
      payload = {recipient_address: recipient_address}

      if email_data && email_data.any?
        payload[:email_data] = email_data
      end
      if tags.any?
        payload[:tags] = tags
      end
      if locale
        payload[:locale] = locale
      end

      payload = payload.to_json
      endpoint = "drip_campaigns/#{drip_campaign_id}/activate"
      SendWithUs::ApiRequest.new(@configuration).post(endpoint, payload)
    end

    def remove_from_drip_campaign(recipient_address, drip_campaign_id)
      payload = {
        recipient_address: recipient_address
      }

      payload = payload.to_json
      SendWithUs::ApiRequest.new(@configuration).post("drip_campaigns/#{drip_campaign_id}/deactivate", payload)
    end

    def drip_campaign_details(drip_campaign_id)
      SendWithUs::ApiRequest.new(@configuration).get("drip_campaigns/#{drip_campaign_id}")
    end

    def customer_get(email)
      SendWithUs::ApiRequest.new(@configuration).get("customers/#{email}")
    end

    def customer_create(email, data = {}, locale = nil)
      payload = {email: email}

      payload[:data] = data if data && data.any?
      payload[:locale] = locale if locale

      payload = payload.to_json
      endpoint = "customers"
      SendWithUs::ApiRequest.new(@configuration).post(endpoint, payload)
    end

    def customer_delete(email_address)
      endpoint = "customers/#{email_address}"
      SendWithUs::ApiRequest.new(@configuration).delete(endpoint)
    end

    def customer_email_log(email_address, options = {})
      endpoint = "customers/#{email_address}/logs"
      params   = {}

      params[:count]       = options[:count]       unless options[:count].nil?
      params[:created_gt]  = options[:created_gt]  unless options[:created_gt].nil?
      params[:created_lt]  = options[:created_lt]  unless options[:created_lt].nil?

      unless params.empty?
        params   = URI.encode_www_form(params)
        endpoint = endpoint + '?' + params
      end

      SendWithUs::ApiRequest.new(@configuration).get(endpoint)
    end

    def log(log_id)
      endpoint = "logs/#{log_id}"

      SendWithUs::ApiRequest.new(@configuration).get(endpoint)
    end

    def log_events(log_id)
      endpoint = "logs/#{log_id}/events"

      SendWithUs::ApiRequest.new(@configuration).get(endpoint)
    end

    def delete_template(template_id)
      endpoint = "templates/#{template_id}"
      SendWithUs::ApiRequest.new(@configuration).delete(endpoint)
    end

    def list_template_versions(template_id)
      endpoint = "templates/#{template_id}/versions"
      SendWithUs::ApiRequest.new(@configuration).get(endpoint)
    end

    def get_template_version(template_id, version_id)
      endpoint = "templates/#{template_id}/versions/#{version_id}"
      SendWithUs::ApiRequest.new(@configuration).get(endpoint)
    end

    def update_template_version(template_id, version_id, name, subject, html, text, preheader='', amp_html='', template_data={})
      payload = {
        name: name,
        subject: subject,
        html: html,
        text: text,
        preheader: preheader,
        amp_html: amp_html,
        template_data: template_data
      }

      endpoint = "templates/#{template_id}/versions/#{version_id}"
      SendWithUs::ApiRequest.new(@configuration).put(endpoint, payload.to_json)
    end

    def create_template_version(template_id, name, subject, html, text, preheader='', amp_html='', template_data={})
      payload = {
        name: name,
        subject: subject,
        html: html,
        text: text,
        preheader: preheader,
        amp_html: amp_html,
        template_data: template_data
      }

      endpoint = "templates/#{template_id}/versions"
      SendWithUs::ApiRequest.new(@configuration).post(endpoint, payload.to_json)
    end
  end
end
