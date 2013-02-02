##
# Send With Us Ruby API Client
#
# Copyright sendwithus 2013
# Author: matt@sendwithus.com
# See: http://github.com/sendwithus for more

require 'test/unit'
require 'lib/sendwithus'

API_PROTO = 'http'
API_HOST = 'beta.sendwithus.com'
API_PORT = '80'
API_KEY = 'THIS_IS_A_TEST_API_KEY'

class TestRubygemSendwithus < Test::Unit::TestCase
  
  ##
  # Unit Test class
  #

  def setup
  end

  def test_send_email
    # ... tests sending an email against a local server
    
    options = {
        :api_host => API_HOST, 
        :api_port => API_PORT, 
        :api_proto => API_PROTO,
        :debug => true
    }

    api = SendWithUs::API.new(API_KEY, options)

    data = {'name' => 'Ruby test'}
    api.send('test', 'test@sendwithus.com', data)

    return true
  end
end

