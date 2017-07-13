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

*NOTE* - If a customer does not exist by the specified email (recipient address), the send call will create a customer.

#### send_email arguments
- **template\_id** - *string* - Template ID being sent
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
- **template\_id** - *string* - Template ID being sent
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
- **strict** - *bool* - This option enables strict mode and is disabled by default (optional)

```ruby
require 'rubygems'
require 'send_with_us'

begin
    obj = SendWithUs::Api.new( api_key: 'YOUR API KEY', debug: true )

    result = obj.render(
        'template_id',
        'version_id',
        { company_name: 'TestCo' },
		strict=true)

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

    result = obj.drips_unsubscribe('customer@example.com')

    puts result
rescue => e
    puts "Error - #{e.class.name}: #{e.message}"
end
```

### Using Drip Campaigns

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
    result = obj.start_on_drip_campaign('customer@example.com', 'dc_asdf1234')
    puts result

    OR

    # Add customer@example.com to campaign dc_asdf1234, with optional: email_data, locale, tags
    result = obj.start_on_drip_campaign('customer@example.com', 'dc_asdf1234', {total: '100.00'}, 'en-US', ['tag1', 'tag2'])
    puts result

    # Remove customer@example.com from campaign dc_asdf1234
    result = obj.remove_from_drip_campaign('cusomter@example.com', 'dc_asdf1234')
    puts result
    rescue => e
    puts "error - #{e.class.name}: #{e.message}"
end
```

## Customers

### Get a Customer

```ruby
customer = obj.customer_get("visha@example.com")
```

### Create/Update a Customer

```ruby
customer_data = {:FirstName => "Visha"}
result = obj.customer_create("visha@example.com")
```

### Delete a Customer

```ruby
result = obj.customer_delete("visha@example.com")
```

### Get logs for customer
This will retrieve email logs for a customer.

Optional Arguments:
- **count** – The number of logs to return. _Max: 100, Default: 100._
- **created_gt** – Return logs created strictly after the given UTC timestamp.
- **created_lt** – Return logs created strictly before the given UTC timestamp.


```ruby
obj.customer_email_log('customer@example.com', count: 1)
```

## Templates

```ruby

# List Templates
obj.list_templates() # Alternatively, obj.emails()

# Create Template
obj.create_template(name, subject, html, text)

# Delete Template
obj.delete_template(template_id)

# List Template Versions
obj.list_template_versions(template_id)

# Update Template Version
obj.update_template_version(template_id, version_id, name, subject, html, text)

# Create Template Version
obj.create_template_version(template_id, name, subject, html, text)

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

Take a look at our Mailer that you can use similarly to ActionMailer

[sendwithus_ruby_action_mailer](https://github.com/sendwithus/sendwithus_ruby_action_mailer)


## Logs

Optional Arguments:
- **count** – The number of logs to return. _Max: 100, Default: 100._
- **offset** – Offset the number of logs to return. _Default: 0_
- **created_gt** – Return logs created strictly after the given UTC timestamp.
- **created_gte** – Return logs created on or after the given UTC timestamp.
- **created_lt** – Return logs created strictly before the given UTC timestamp.
- **created_lte** – Return logs created on or before the given UTC timestamp.

```ruby
obj.logs(count: 1, offset: 1)
```

## Errors

The following errors may be generated:

```ruby
SendWithUs::ApiInvalidEndpoint - the target URI is probably incorrect or template_id is invalid
SendWithUs::ApiInvalidKey - the sendwithus API key is invalid
SendWithUs::ApiBadRequest - the API request is invalid
SendWithUs::ApiConnectionRefused - the target URI is probably incorrect
SendWithUs::ApiUnknownError - an unhandled HTTP error occurred
```

## Running tests
Use [rake](https://github.com/ruby/rake) to run the tests:

```sh
$: rake
```

## Troubleshooting

### General Troubleshooting

-   Enable debug mode
-   Make sure you're using the latest Ruby client
-   Capture the response data and check your logs &mdash; often this will have the exact error

### Enable Debug Mode

Debug mode prints out the underlying request information as well as the data payload that gets sent to sendwithus. You will most likely find this information in your logs. To enable it, simply put `debug: true` as a parameter when instantiating the API object. Use the debug mode to compare the data payload getting sent to [sendwithus' API docs](https://www.sendwithus.com/docs/api "Official Sendwithus API Docs").

```php
obj = SendWithUs::Api.new( api_key: 'YOUR API KEY', debug: true )
```

### Response Ranges

Sendwithus' API typically sends responses back in these ranges:

-   2xx – Successful Request
-   4xx – Failed Request (Client error)
-   5xx – Failed Request (Server error)

If you're receiving an error in the 400 response range follow these steps:

-   Double check the data and ID's getting passed to Sendwithus
-   Ensure your API key is correct
-   Log and check the body of the response


## Internal
Build gem with

```bash
gem build send_with_us.gemspec
```

Publish gem with

```bash
gem push send_with_us-VERSION.gem
```
