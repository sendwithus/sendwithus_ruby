# sendwithus_ruby

Ruby bindings for sending email via the sendwithus API.

[sendwithus.com](http://sendwithus.com)

[![Build Status](https://api.travis-ci.org/sendwithus/sendwithus_ruby.png)](https://travis-ci.org/sendwithus/sendwithus_ruby)

## Installation

```bash
gem install send_with_us
```

or with Bundler:

```bash
gem 'send_with_us'
bundle install
```

## Usage

### General

For any Ruby project:
```ruby
require 'rubygems'
require 'send_with_us'

begin
    obj = SendWithUs::Api.new( api_key: 'YOUR API KEY', debug: true )

    # only required params
    result = obj.send_with(
        'EMAIL_ID',
        { address: "user@email.com" })
    puts result
    
    # with all optional params
    result = obj.send_with(
        'email_id',
        { name: 'Matt', address: 'recipient@testco.com' },
        { company_name: 'TestCo' },
        { name: 'Company',
            address: 'company@testco.com',
            reply_to: 'info@testco.com' })
    puts result
    
    # full cc/bcc support
    result = obj.send_with(
        'email_id',
        { name: 'Matt', address: 'recipient@testco.com' },
        { company_name: 'TestCo' },
        { name: 'Company',
            address: 'company@testco.com',
            reply_to: 'info@testco.com' },
        [
            { name: 'CC',
                address: 'cc@testco.com' }
        ],
        [
            { name: 'BCC',
                address: 'bcc@testco.com' },
            { name: 'BCC2',
                address: 'bcc2@test.com' }
        ])

    # Attachment support
    result = obj.send_with(
        'email_id',
        { name: 'Matt', address: 'recipient@testco.com' },
        { company_name: 'TestCo' },
        { name: 'Company',
            address: 'company@testco.com',
            reply_to: 'info@testco.com' },
        [],
        [],
        ['path/to/file.txt'])

    puts result
rescue => e
    puts "Error - #{e.class.name}: #{e.message}"
end
```

### Rails

For a Rails app, create `send_with_us.rb` in `/config/initializers/`
with the following:

```ruby
SendWithUs::Api.configure do |config|
    config.api_key = 'YOUR API KEY'
    config.debug = true
end
```

In your application code where you want to send an email:

```ruby
begin
    result = SendWithUs::Api.new.send_with('email_id', { address: 'recipient@testco.com' }, { company_name: 'TestCo' })
    puts result
rescue => e
    puts "Error - #{e.class.name}: #{e.message}"
end
```

## Errors

The following errors may be generated:

```ruby
SendWithUs::ApiInvalidEndpoint - the target URI is probably incorrect or email_id is invalid
SendWithUs::ApiConnectionRefused - the target URI is probably incorrect
SendWithUs::ApiUnknownError - an unhandled HTTP error occurred
```

## Internal
Build gem with

```bash
gem build send_with_us.gemspec
```

Publish gem with

```bash
gem push send_with_us-VERSION.gem
```

