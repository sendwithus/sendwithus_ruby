require_relative '../../test_helper'

class TestApiRequest < MiniTest::Unit::TestCase

  def build_objects
    @payload = {}
    @api = SendWithUs::Api.new( api_key: 'THIS_IS_A_TEST_API_KEY', debug: false)
    @config  = SendWithUs::Config.new( api_version: '1_0', api_key: 'THIS_IS_A_TEST_API_KEY', debug: false )
    @request = SendWithUs::ApiRequest.new(@config)
    @drip_campaign = { :drip_campaign_id => 'dc_Rmd7y5oUJ3tn86sPJ8ESCk', :drip_campaign_step_id => 'dcs_yaAMiZNWCLAEGw7GLjBuGY', :recipient_address => 'person@example.com'}
    @customer = { :email => "steve@sendwithus.com" }
  end

  def test_payload
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post(:send, @payload) )
  end

  def test_attachment
    build_objects
    email_id = 'test_fixture_1'
    result = @api.send_with(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      {name: 'sendwithus', address: 'matt@example.com'},
      {},
      [],
      [],
      ['README.md']
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_unsubscribe
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post(:'drips/unsubscribe', @payload) )
  end

  def test_send_with_not_found_exception
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPNotFound.new(1.0, 404, "OK"))
    assert_raises( SendWithUs::ApiInvalidEndpoint ) { @request.post(:send, @payload) }
  end

  def test_send_with_forbidden_exception
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPForbidden.new(1.0, 403, "OK"))
    assert_raises( SendWithUs::ApiInvalidKey ) { @request.post(:send, @payload) }
  end

  def test_send_with_bad_request
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPBadRequest.new(1.0, 400, "OK"))
    assert_raises( SendWithUs::ApiBadRequest ) { @request.post(:send, @payload) }
  end

  def test_send_with_unknown_exception
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPNotAcceptable.new(1.0, 406, "OK"))
    assert_raises( SendWithUs::ApiUnknownError ) { @request.post(:send, @payload) }
  end

  def test_send_with_connection_refused
    build_objects
    Net::HTTP.any_instance.stubs(:request).raises(Errno::ECONNREFUSED.new)
    assert_raises( SendWithUs::ApiConnectionRefused ) { @request.post(:send, @payload) }
  end

  def test_send_with_version
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.send_with(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      {name: 'sendwithus', address: 'matt@example.com'},
      {},
      [],
      [],
      [],
      '',
      'v2'
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_send_with_headers
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.send_with(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      {name: 'sendwithus', address: 'matt@example.com'},
      {},
      [],
      [],
      [],
      '',
      'v2',
      {'X-MY-HEADER' => 'foo'}
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_emails
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.get(:emails) )
  end

  def test_list_drip_campaigns
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.get(:list_drip_campaigns) )
  end

  def test_start_on_drip_campaign
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.start_on_drip_campaign(@drip_campaign[:recipient_address], @drip_campaign[:drip_campaign_id], @payload)
    assert_instance_of( Net::HTTPSuccess, result)
  end

  def test_remove_from_drip_campaign
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.remove_from_drip_campaign(@drip_campaign[:recipient_address], @drip_campaign[:drip_campaign_id])
    assert_instance_of( Net::HTTPSuccess, result )
  end

  def test_drip_campaign_details
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.drip_campaign_details(@drip_campaign[:drip_campaign_id])
    assert_instance_of( Net::HTTPSuccess, result )
  end

  def test_list_customers_on_campaign
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.list_customers_on_campaign(@drip_campaign[:drip_campaign_id])
    assert_instance_of( Net::HTTPSuccess, result )
  end

  def test_list_customers_on_campaign_step
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.list_customers_on_campaign(@drip_campaign[:drip_campaign_id])
    assert_instance_of( Net::HTTPSuccess, result )
  end

  def test_request_path
    build_objects
    assert_equal( true, @request.send(:request_path, :send) == '/api/v1_0/send' )
  end

  def test_add_user_event()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.add_customer_event(@customer[:email], 'purchase')
    assert_instance_of( Net::HTTPSuccess, result )
  end

  def test_conversion_event()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.customer_conversion(@customer[:email])
    assert_instance_of( Net::HTTPSuccess, result)
  end

  def test_customer_create()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.customer_create(@customer[:email])
    assert_instance_of( Net::HTTPSuccess, result )
  end

  def test_customer_delete()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    result = @api.customer_delete(@customer[:email])
    assert_instance_of( Net::HTTPSuccess, result )
  end

end
