
require 'test/unit'
require 'lib/sendwithus'

API_PORT = '8000'
API_HOST = 'localhost'
API_PROTO = 'http'
API_KEY = ''

class TestRubygemSendwithus < Test::Unit::TestCase

    def setup
    end

    def test_truth
        assert true
    end

    def test_simple
        api = SendWithUs::API.new(API_KEY, :api_host => API_PORT, :api_port => API_PORT, :api_proto => API_PROTO)

        data = {'name' => 'Jimmy'}
        api.send('test_email', 'matt@sendwithus.com', data)

        return true
    end
end

