module SendWithUs
  class Config
    attr_accessor :settings
    #attr_writer :url, :api_key, :protocol, :host, :port, :api_verstion, :debug

    DEFAULT_URL = 'https://beta.sendwithus.com'

    def self.defaults
      source = URI.parse(DEFAULT_URL)

      {
        url: DEFAULT_URL,
        api_key:      'CATS',
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
      meth_str = meth.to_s

      if meth_str.include?('=')
        # If this is a write attempt, see if we can write to that key
        meth_sym = meth_str.gsub('=', '').to_sym
        has?(meth_sym) ? @settings[meth_sym] = args[0] : super
      else
        # It's a read attempt, see if that key exists
        has?(meth) ? @settings[meth] : super
      end
    end

    def respond_to_missing?(meth, include_private = false)
      has?(meth) || super
    end

    private

      def has?(key)
        @settings.has_key?(key)
      end
  end
end
