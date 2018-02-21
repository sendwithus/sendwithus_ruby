module SendWithUs
end

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

require 'send_with_us/attachment'
require 'send_with_us/file'
require 'send_with_us/api'
require 'send_with_us/api_request'
require 'send_with_us/config'
require 'send_with_us/version' unless defined?(SendWithUs::VERSION)
