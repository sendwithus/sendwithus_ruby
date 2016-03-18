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
      before { SendWithUs::ApiRequest.any_instance.expects(:get).with('logs') }

      it { subject.logs }
    end
    describe 'with options' do
      let(:options) { { count: 2 } }
      before { SendWithUs::ApiRequest.any_instance.expects(:get).with('logs?count=2') }

      it { subject.logs(options) }
    end
  end

  describe '#customer_email_log' do
    describe 'without options' do
      let(:options) { nil }
      let(:email) { 'some@email.stub' }
      before { SendWithUs::ApiRequest.any_instance.expects(:get).with("customers/#{email}/logs") }

      it { subject.customer_email_log(email) }
    end
    describe 'with options' do
      let(:options) { { count: 2 } }
      let(:email) { 'some@email.stub' }
      before { SendWithUs::ApiRequest.any_instance.expects(:get).with("customers/#{email}/logs?count=2") }

      it { subject.customer_email_log(email, options) }
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

  describe '#start_on_drip_campaign' do
    let(:email) { 'some@email.stub' }
    let(:drip_campaign_id) { 'dc_SoMeCampaIGnID' }
    let(:locale) { "en-US" }
    let(:tags) { ['tag1', 'tag2'] }
    let(:endpoint) { "drip_campaigns/#{drip_campaign_id}/activate" }

    before { SendWithUs::ApiRequest.any_instance.expects(:post).with(endpoint, payload.to_json) }

    describe 'email_data' do
      let(:payload) { {recipient_address: email, email_data: {foo: 'bar'}} }

      it { subject.start_on_drip_campaign(email, drip_campaign_id, {foo: 'bar'}) }
    end

    describe 'email_data & tags' do
      let(:payload) { {recipient_address: email, email_data: {foo: 'bar'}, tags: tags, locale: locale} }

      it { subject.start_on_drip_campaign(email, drip_campaign_id, {foo: 'bar'}, locale, tags) }
    end

    describe 'tags' do
      let(:payload) { {recipient_address: email, tags: tags, locale: locale} }

      it { subject.start_on_drip_campaign(email, drip_campaign_id, {}, locale, tags) }
    end
  end
end
