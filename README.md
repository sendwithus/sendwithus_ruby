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
        { address: "user@example.com" })
    puts result

    # with all optional params
    result = obj.send_with(
        'email_id',
        { name: 'Matt', address: 'recipient@example.com' },
        { company_name: 'TestCo' },
        { name: 'Company',
            address: 'company@example.com',
            reply_to: 'info@example.com' })
    puts result

    # full cc/bcc support
    result = obj.send_with(
        'email_id',
        { name: 'Matt', address: 'recipient@example.com' },
        { company_name: 'TestCo' },
        { name: 'Company',
            address: 'company@example.com',
            reply_to: 'info@example.com' },
        [
            { name: 'CC',
                address: 'cc@example.com' }
        ],
        [
            { name: 'BCC',
                address: 'bcc@example.com' },
            { name: 'BCC2',
                address: 'bcc2@example.com' }
        ])
    puts result

    # Attachment support
    result = obj.send_with(
        'email_id',
        { name: 'Matt', address: 'recipient@example.com' },
        { company_name: 'TestCo' },
        { name: 'Company',
            address: 'company@example.com',
            reply_to: 'info@example.com' },
        [],
        [],
        ['path/to/file.txt'])
    puts result

    # Set ESP account
    # See: https://help.sendwithus.com/support/solutions/articles/1000088976-set-up-and-use-multiple 
    result = obj.send_with(
        'email_id',
        { name: 'Matt', address: 'recipient@example.com' },
        { company_name: 'TestCo' },
        { name: 'Company',
            address: 'company@example.com',
            reply_to: 'info@example.com' },
        [],
        [],
        [],
        'esp_MYESPACCOUNT')
    puts result
rescue => e
    puts "Error - #{e.class.name}: #{e.message}"
end
```

### Remove Customer from Drip Campaign
```ruby
require 'rubygems'
require 'send_with_us'

begin
    obj = SendWithUs::Api.new( api_key: 'YOUR API KEY', debug: true )

    result = obj.drip_unsubscribe('customer@example.com')

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
    result = SendWithUs::Api.new.send_with('email_id', { address: 'recipient@example.com' }, { company_name: 'TestCo' })
    puts result
rescue => e
    puts "Error - #{e.class.name}: #{e.message}"
end
```

Take a look at our Mailer that you can use to replace ActionMailer

[sendwithus_ruby_action_mailer](https://github.com/sendwithus/sendwithus_ruby_action_mailer)


## Errors

The following errors may be generated:

```ruby
SendWithUs::ApiInvalidEndpoint - the target URI is probably incorrect or email_id is invalid
SendWithUs::ApiInvalidKey - the sendwithus API key is invalid
SendWithUs::ApiBadRequest - the API request is invalid
SendWithUs::ApiConnectionRefused - the target URI is probably incorrect
SendWithUs::ApiUnknownError - an unhandled HTTP error occurred
```


## Updating

1. Implement changes (and tests!)
2. Test in `irb` with `$ bundle console`
3. Update the version in `lib/send_with_us/version.rb`
4. Update `CHANGELOG.md`
4. Re-bundle with `$ bundle package`
5. Re-build with `$ gem build send_with_us.gemspec`
6. Push changes to Github etc.
7. Code review & merge
8. Push gem to server with `$ gem push send_with_us-FIXME_VERSION.gem`


## Internal
Build gem with

```bash
gem build send_with_us.gemspec
```

Publish gem with

```bash
gem push send_with_us-VERSION.gem
```
