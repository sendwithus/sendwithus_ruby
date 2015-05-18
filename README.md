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

### Send

#### send_email arguments
- **email\_id** - *string* - Template ID being sent
- **to** - *hash* - Recipients' email address
- **:data** - *hash* - Email data
- **:from** - *hash* - From name/address/reply\_to
- **:cc** - *array* - array of CC addresses
- **:bcc** - *array* - array of BCC addresses
- **:files** - *array* - array of files to attach, as strings or hashes (see below)
- **:esp\_account** - *string* - ESP account used to send email
- **:version\_name** - *string* - version of template to send
- **:headers** - *hash* - custom email headers **NOTE** only supported by some ESPs
- **:tags** - *array* - array of strings to attach as tags
- **:locale** - *string* - Localization string

#### send_with arguments [DEPRECATED]
- **email\_id** - *string* - Template ID being sent
- **to** - *hash* - Recipients' email address
- **data** - *hash* - Email data
- **from** - *hash* - From name/address/reply\_to
- **cc** - *array* - array of CC addresses
- **bcc** - *array* - array of BCC addresses
- **files** - *array* - array of files to attach, as strings or hashes (see below)
- **esp\_account** - *string* - ESP account used to send email
- **version\_name** - *string* - version of template to send
- **headers** - *hash* - custom email headers **NOTE** only supported by some ESPs
- **tags** - *array* - array of strings to attach as tags


For any Ruby project:
```ruby
require 'rubygems'
require 'send_with_us'

begin
    obj = SendWithUs::Api.new( api_key: 'YOUR API KEY', debug: true )

    # required params
    result = obj.send_email(
        'template_id',
        { address: "user@example.com" })
    puts result

    # required params and locale
    result = obj.send_email(
        'template_id',
        { address: "user@example.com" }),
        locale: 'en-US'
    puts result

    # full cc/bcc support
    result = obj.send_email(
        'template_id',
        { name: 'Matt', address: 'recipient@example.com' },
        data: { company_name: 'TestCo' },
        from: { name: 'Company',
            address: 'company@example.com',
            reply_to: 'info@example.com' },
        cc: [
            { name: 'CC',
                address: 'cc@example.com' }
        ],
        bcc: [
            { name: 'BCC',
                address: 'bcc@example.com' },
            { name: 'BCC2',
                address: 'bcc2@example.com' }
        ])
    puts result

    # Attachment support
    result = obj.send_email(
        'template_id',
        { name: 'Matt', address: 'recipient@example.com' },
        data: { company_name: 'TestCo' },
        from: { name: 'Company',
            address: 'company@example.com',
            reply_to: 'info@example.com' },
        cc: [],
        bcc: [],
        files: [
          'path/to/file.txt',
          { filename: 'customfilename.txt', attachment: 'path/to/file.txt' },
          { filename: 'anotherfile.txt', attachment: File.open('path/to/file.txt') },
          { filename: 'unpersistedattachment.txt', attachment: StringIO.new("raw data") }
        ]
    )
    puts result

    # Set ESP account
    # See: https://help.sendwithus.com/support/solurtions/articles/1000088976-set-up-and-use-multiple
    result = obj.send_email(
        'template_id',
        { name: 'Matt', address: 'recipient@example.com' },
        data: { company_name: 'TestCo' },
        from: { name: 'Company',
            address: 'company@example.com',
            reply_to: 'info@example.com' },
        cc: [],
        bcc: [],
        files: [],
        esp_account: 'esp_MYESPACCOUNT')
    puts result

    # all possible arguments
    result = obj.send_email(
        'template_id',
        { name: 'Matt', address: 'recipient@example.com' },
        data: { company_name: 'TestCo' },
        from: {
          name: 'Company',
          address: 'company@example.com',
          reply_to: 'info@example.com'
        },
        cc: [
            { name: 'CC',
                address: 'cc@example.com' }
        ],
        bcc: [
            { name: 'BCC',
                address: 'bcc@example.com' },
            { name: 'BCC2',
                address: 'bcc2@example.com' }
        ],
        files: ['path/to/attachment.txt'],
        esp_account: 'esp_MYESPACCOUNT',
        version: 'v2',
        tags: ['tag1', 'tag2'],
        locale: 'en-US')
    puts result

    # send_with - DEPRECATED!
    result = obj.send_with(
        'template_id',
        { name: 'Matt', address: 'recipient@example.com' },
        { company_name: 'TestCo' },
        {
          name: 'Company',
          address: 'company@example.com',
          reply_to: 'info@example.com'
        },
        [
            { name: 'CC',
                address: 'cc@example.com' }
        ],
        [
            { name: 'BCC',
                address: 'bcc@example.com' },
            { name: 'BCC2',
                address: 'bcc2@example.com' }
        ],
        ['path/to/attachment.txt'],
		'esp_MYESPACCOUNT',
		'v2',
        ['tag1', 'tag2'],
        'en-US')
    puts result
rescue => e
    puts "Error - #{e.class.name}: #{e.message}"
end
```

### Render a Template

- **email\_id** - *string* - Template ID being rendered
- **version\_id** - *string* - Version ID to render (optional)
- **data** - *hash* - Email data to render the template with (optional)
- **data[:locale]** - *hash value* - This option specifies the locale to render (optional)

```ruby
require 'rubygems'
require 'send_with_us'

begin
    obj = SendWithUs::Api.new( api_key: 'YOUR API KEY', debug: true )

    result = obj.render(
        'template_id',
        'version_id',
        { company_name: 'TestCo' },

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

### Using Drips 2.0

```ruby
require 'rubygems'
require 'send_with_us'

begin
    obj = SendWithUs::Api.new( api_key: 'YOUR API KEY', debug: true )

    # List campaigns
    result = obj.list_drip_campaigns()
    puts result

    # List steps of campaign dc_asdf1234
    result = obj.drip_campaign_details('dc_asdf1234')
    puts result

    # Add customer@example.com to campaign dc_asdf1234
    result = obj.start_on_drip_campaign('customer@example.com', 'dc_asdf1234', {location: 'Canada', total: '100.00'})
    puts result

    # Remove customer@example.com from campaign dc_asdf1234
    result = obj.remove_from_drip_campaign('cusomter@example.com', 'dc_asdf1234')
    puts result
    rescue => e
    puts "error - #{e.class.name}: #{e.message}"
end
```

## Customers

### Create/Update a Customer

```ruby
customer_data = {:FirstName => "Visha"}
result = obj.customer_create("visha@example.com", customer_data)
```

### Delete a Customer

```ruby
result = obj.customer_delete("visha@example.com")
```

### Customer Conversion Event
You can use the Conversion API to track conversion and revenue data events against your sent emails

**NOTE:** Revenue is in cents (eg. $100.50 = 10050)

```ruby
# With Revenue
obj.customer_conversion('customer@example.com', 10050)

# Without Revenue
obj.customer_conversion('customer@example.com')
```

## Rails

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
    result = SendWithUs::Api.new.send_with('template_id', { address: 'recipient@example.com' }, { company_name: 'TestCo' })
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
SendWithUs::ApiInvalidEndpoint - the target URI is probably incorrect or template_id is invalid
SendWithUs::ApiInvalidKey - the sendwithus API key is invalid
SendWithUs::ApiBadRequest - the API request is invalid
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
