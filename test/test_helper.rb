require 'minitest/autorun'
require 'minitest/pride'

require File.expand_path('../../lib/send_with_us.rb', __FILE__)

require 'rubygems'
require 'bundler'
require "mocha/mini_test"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'send_with_us'
