require_relative '../../test_helper'

describe SendWithUs::Api do
  let(:subject) { SendWithUs::Api.new }

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

  describe '#logs' do
    describe 'without options' do
      let(:options) { nil }
      before { SendWithUs::ApiRequest.any_instance.expects(:get).with('logs', {}.to_json) }

      it { subject.logs }
    end

    describe 'with options' do
      let(:options) { {count: 2, offset: 10} }
      before { SendWithUs::ApiRequest.any_instance.expects(:get).with('logs', options.to_json) }

      it { subject.logs(options) }
    end
  end

  describe '#log' do
    describe 'with log_id' do
      let(:log_id) { 'log_TESTTEST123' }
      before { SendWithUs::ApiRequest.any_instance.expects(:get).with("logs/#{log_id}") }

      it { subject.log(log_id) }
    end

    describe 'without log_id' do
      it { -> { subject.log }.must_raise ArgumentError }
    end
  end
end
