require_relative '../../test_helper'

describe SendWithUs::Api do

  describe '.configuration with initializer' do
    before do
      @initializer_api_key = 'CONFIG_TEST'
      SendWithUs::Api.configure { |config| config.api_key = @initializer_api_key }
    end

    it('configs') { SendWithUs::Api.new.configuration.api_key.must_equal @initializer_api_key }
  end

  describe '.configuration with custom' do
    before do
      @initializer_api_key = 'CONFIG_TEST'
      @custom_api_key = 'STUFF_AND_THINGS'
      SendWithUs::Api.configure { |config| config.api_key = @initializer_api_key }
    end

    it('configs') { SendWithUs::Api.new( api_key: @custom_api_key ).configuration.api_key.must_equal @custom_api_key }
  end

end
