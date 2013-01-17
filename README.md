sendwithus
===========

Send With Us Ruby client


## Usage

    require 'sendwithus'

    options = {
        :api_host => API_HOST, 
        :debug => true
    }
    api = SendWithUs::API.new(API_KEY, options)
    data = {'name' => 'Ruby test'}
    api.send_email( 'test_send', 'matt@sendwithus.com', data )

