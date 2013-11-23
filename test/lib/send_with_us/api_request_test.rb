require_relative '../../test_helper'

class TestApiRequest < MiniTest::Unit::TestCase

  def build_objects
    @payload = {}
    @config  = SendWithUs::Config.new( api_version: '1_0', api_key: 'THIS_IS_A_TEST_API_KEY', debug: false )
    @request = SendWithUs::ApiRequest.new(@config)
  end

  def test_payload
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.send_with(@payload) )
  end

  def test_unsubscribe
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.drips_unsubscribe(@payload) )
  end

  def test_send_with_not_found_exception
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPNotFound.new(1.0, 404, "OK"))
    assert_raises( SendWithUs::ApiInvalidEndpoint ) { @request.send_with(@payload) }
  end

  def test_send_with_unknown_exception
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPNotAcceptable.new(1.0, 406, "OK"))
    assert_raises( SendWithUs::ApiUnknownError ) { @request.send_with(@payload) }
  end

  def test_send_with_connection_refused
    build_objects
    Net::HTTP.any_instance.stubs(:request).raises(Errno::ECONNREFUSED.new)
    assert_raises( SendWithUs::ApiConnectionRefused ) { @request.send_with(@payload) }
  end

  def test_emails
    build_objects
    Net::HTTP.any_instance.stubs(:request).returns(Net::HTTPSuccess.new(1.0, 200, "OK"))
    assert_instance_of( Net::HTTPSuccess, @request.get(:emails) )
  end

  def test_request_path
    build_objects
    assert_equal( true, @request.send(:request_path, :send) == '/api/v1_0/send' )
  end

end
