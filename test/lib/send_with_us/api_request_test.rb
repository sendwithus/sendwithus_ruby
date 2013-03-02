
require_relative '../../test_helper'

class TestApiRequest < MiniTest::Unit::TestCase

  def build_objects
    @config   = SendWithUs::Config.new( api_version: 3 )
    @request  = SendWithUs::ApiRequest.new(@config)
  end

  def test_payload

  end

  def test_payload_exceptions

  end

  def test_request_path
    build_objects
    assert_equal( true, @request.send(:request_path, :send) == '/api/v3/send' )
  end

end
