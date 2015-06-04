require_relative '../../test_helper'

class TestApiRequest < Minitest::Test

  def build_objects
    @payload = {}
    @api = SendWithUs::Api.new( api_key: 'THIS_IS_A_TEST_API_KEY', debug: false)
    @config  = SendWithUs::Config.new( api_version: '1_0', api_key: 'THIS_IS_A_TEST_API_KEY', debug: false )
    @request = SendWithUs::ApiRequest.new(@config)
    @drip_campaign = { :drip_campaign_id => 'dc_Rmd7y5oUJ3tn86sPJ8ESCk', :drip_campaign_step_id => 'dcs_yaAMiZNWCLAEGw7GLjBuGY' }
    @customer = { :email => "steve@sendwithus.com" }
  end

  def test_payload
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post(:send, @payload) )
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
    bad_request = Net::HTTPBadRequest.new(1.0, 400, 'OK')
    bad_request.stubs(:body).returns("This is a test body")
    Net::HTTP.any_instance.stubs(:request).returns(bad_request)
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

  def test_send_with_with_attachment
    build_objects
    email_id = 'test_fixture_1'
    result = @api.send_with(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      {data: 'I AM DATA'},
      {name: 'sendwithus', address: 'matt@example.com'},
      [],
      [],
      ['README.md']
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_send_with_with_version
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.send_with(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      {data: 'I AM DATA'},
      {name: 'sendwithus', address: 'matt@example.com'},
      [],
      [],
      [],
      '',
      'v2'
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_send_with_with_headers
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.send_with(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      {data: 'I AM DATA'},
      {name: 'sendwithus', address: 'matt@example.com'},
      [],
      [],
      [],
      '',
      'v2',
      {'X-MY-HEADER' => 'foo'}
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_send_with_with_tags
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.send_with(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      {data: 'I AM DATA'},
      {name: 'sendwithus', address: 'matt@example.com'},
      [],
      [],
      [],
      '',
      'v2',
      {},
      ['tag1', 'tag2']
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_send_with_tags
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.send_email(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      data: {data: 'I AM DATA'},
      from: {name: 'sendwithus', address: 'matt@example.com'},
      version_name: 'v2',
      tags: ['tag1', 'tag2']
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_send_with_locale
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.send_email(
      email_id,
      {name: 'Ruby Unit Test', address: 'matt@example.com'},
      data: {data: 'I AM DATA'},
      from: {name: 'sendwithus', address: 'matt@example.com'},
      version_name: 'v2',
      tags: ['tag1', 'tag2'],
      locale: 'en-US'
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_render
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.render(
      email_id
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_render_with_version
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.render(
      email_id,
      'ver_UQuRkPN7aJjEoNfoHzvffD'
    )
    assert_instance_of( Net::HTTPOK, result )
  end

  def test_render_with_version_and_data
    build_objects
    email_id = 'tem_9YvYsaLW2Mw4tmPiLcVvpC'
    result = @api.render(
      email_id,
      'ver_UQuRkPN7aJjEoNfoHzvffD',
      {'foo' => 'bar'}
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
    assert_instance_of( Net::HTTPSuccess, @request.get(:'drip_campaigns') )
  end

  def test_get_with_params_for_logs
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.get(:'logs', {count: 10}.to_json) )
  end

  def test_start_on_drip_campaign
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post("drip_campaigns/#{@drip_campaign[:drip_campaign_id]}/activate", @payload) )
  end

  def test_remove_from_drip_campaign
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post("drip_campaigns/#{@drip_campaign[:drip_campaign_id]}/deactivate", @payload) )
  end

  def test_drip_campaign_details
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.get("drip_campaigns/#{@drip_campaign[:drip_campaign_id]}") )
  end

  def test_list_customers_on_campaign
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.get("drip_campaigns/#{@drip_campaign[:drip_campaign_id]}/customers") )
  end

  def test_list_customers_on_campaign_step
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.get("drip_campaigns/#{@drip_campaign[:drip_campaign_id]}/step/#{@drip_campaign[:drip_campaign_step_id]}/customers") )
  end

  def test_request_path
    build_objects
    assert_equal( true, @request.send(:request_path, :send) == '/api/v1_0/send' )
  end

  def test_add_user_event()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post(:'customers/test@sendwithus.com/conversions', @payload))
  end

  def test_conversion_event()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post(:'customers/test@sendwithus.com/conversions', @payload))
  end

  def test_customer_create()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.post(:'customers', @customer))
  end

  def test_customer_delete()
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.delete(:'customers/#{@customer[:email]}'))
  end

end
