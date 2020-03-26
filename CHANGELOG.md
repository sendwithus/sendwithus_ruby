## 4.2.1
- Bump `rake` version due to vulnerability 

## 4.2.0
- add a `log_events` method to get the events list on a Sendwithus log

## 4.1.1
- Fix to encode responses as UTF-8

## 4.1.0
- `send_email` now supports already encoded files

## 4.0.1
- Remove unused methods

## 4.0.0
- Deprecate Logs List API endpoint

## 3.1.0
- Add `strict` option to the render call

## 3.0.0
- Deprecate and remove Conversions API calls

## 2.0.0
- Deprecate Customer Groups API

## 1.13.0
- Add support to get customer details

## 1.12.0
- Customer logs endpoint added and optional parameters for logs fixed when no options sent

## 1.11.5
- Added tags to drip campaign activations

## 1.11.4
- Added optional parameters to customer_create

## 1.11.3
- Fix bug in customer remove method where arguments were empty

## 1.11.2
- Fix bug in logs method where options weren't being respected

## 1.11.1
- Fix typo in group method

## 1.11.0
- Add template create/update methods as well as group create/update methods

## 1.10.2
- Include render parameter on locale

## 1.10.1
- Tag support, error base class, logs method

## 1.9.0
- Locale support.  Introduce send\_email().  Deprecate send\_with().

## 1.8.0
- Tags support for send\_with

## 1.7.0

## 1.6.0

## 1.5.0

## 1.4.3
- Add customer add/deletion support

## 1.1.4
- Add Drips v2.0 support

## 1.0.5
- Add attachment support

## 1.0.4
- Add drip campaign unsubscribe support

## 1.0.3
- Don't allow nil email\_id

## 1.0.2
- More sensible error messages

## 1.0.0
- Updated for v1\_0 of SWU api. Added emails endpoint.

## 0.0.4
- Rewritten to be more gem-like
- Accepts configuration via a Rails-style initializer
- Test coverage

## 0.0.3
- No idea

## 0.0.2
- Full json post body

## 0.0.1
- First Version
