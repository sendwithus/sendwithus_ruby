module SendWithUs
  class Config

    DEFAULT_URL = 'https://beta.sendwithus.com'

    def self.defaults
      source = URI.parse(DEFAULT_URL)

      {
        url: DEFAULT_URL,
        protocol:     source.scheme,
        host:         source.host,
        port:         source.port,
        api_version:  0,
        debug:        true
      }
    end

    def initialize(options={})
      @settings = SendWithUs::Config.defaults.merge(options)
    end

    def method_missing(meth, *args, &block)
      has?(meth) ? @settings[meth] : super
    end

    def respond_to_missing?(meth, include_private = false)
      has?(meth) || super
    end

    private

      def has?(key)
        @settings.has_key?(key)
      end

      def base_url
        URI.parse("#{protocol}://#{host}:#{port}/api/v#{api_version}")
      end


  end
end
