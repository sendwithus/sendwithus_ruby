module SendWithUs

  class Api
    attr_accessor :api_key

    def initialize(api_key, options = {})
      @api_key = api_key
      @configuration = SendWithUs::Config.new(options)
    end

    def base_url

    end

  end

end
