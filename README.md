# Metova Rails Components [![Build Status](https://travis-ci.org/metova/metova-rails.svg?branch=release)](https://travis-ci.org/metova/metova-rails)

The Metova gem provides a plethora of functionality for Rails apps.

# INCOMPLETE, PLEASE READ

Right now the Metova gem is under development and should *NOT* be used in real applications.

## Installation

```ruby
gem 'metova'
```

Then `bundle install`.

## API Responder

This engine includes a Responder for use with the `responders` gem. Rails responders are executed when calling
`respond_with` in a controller action. To gain the full effect of these libraries, you should always be using
`respond_with` instead of the "default" Rails `respond_to do |format|` blocks.

To enable the Responder, add this line to the top of your API base controller:

```ruby
self.responder = Metova::Responder
```
## Wiki

Please see the Wiki for full documentation!

## Contributing

1. Fork it ( https://github.com/metova/metova-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. **Add Tests**
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
