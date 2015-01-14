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

## Pagination

APIs accept a `page` and `limit` parameter to paginate their results. Pagination information is available to API
consumers via the `Link` header on the response.

```
GET http://*.*/api/posts?page=2&limit=10
# => posts 11-20
# => Link: <http://*.*/api/posts?page=3&limit=10>; rel="next", <http://*.*/api/posts?page=10&limit=10>; rel="last"
```

## Filtering by ID

APIs accept an `ids` parameter to filter the results to records with the provided ids. The `ids` parameter should be
comma delimited. This is useful when your API will only return a list of nested ids instead of embedding
the entire JSON of the nested objects.

For example, to get a user's posts:

```
GET http://*.*/api/users/1
# => { "users": { "id": 1, "posts": [1, 2, 3] } }

GET http://*.*/api/posts?ids=1,2,3
# => { "posts": [{ "id": 1, "author": 1 }, { "id": 2, "author": 1 }, { "id": 3, "author": 1 }] }
```

## Sorting

APIs accept a `sort` parameter to order the results by a field on the requested resource. To change the direction, `asc` or `desc`
can be passed via the `direction` parameter, which defaults to `asc`.

```
GET http://*.*/api/posts?sort=title
# => { "posts": [{ "id": 1, "author": 1, title: 'ABC' }, { "id": 2, "author": 1, title: 'BCD' }] }

GET http://*.*/api/posts?sort=title&direction=desc
# => { "posts": [{ "id": 2, "author": 1, title: 'BCD' }, { "id": 1, "author": 1, title: 'ABC' }] }
```

## API Versioning

Consumers should pass their API version using the `Accept` header:

`Accept: "application/json"; version=X`

In the Rails app, the current API version is given in a routing DSL. When used, any API version that does not match the given version
will result in a `412 Precondition failed` response and the consumer should be forced to upgrade.

```ruby
namespace :api, defaults: { format: 'json' } do
  version 2 do
    resources :posts
    # ...
  end
end
```

## CarrierWave AWS Setup through ENV

When required, metova-rails will setup CarrierWave based on your ENV. To enable this configuration, add "metova/carrierwave"
to the `require` array in your Gemfile:

`gem 'metova', require: ['metova/carrierwave']`

Setting the following ENV variables will configure CarrierWave appropriately. In the test environment, file storage will be used and
processing will be disabled.

```
ENV['AWS_S3_BUCKET_NAME']
ENV['AWS_S3_ACCESS_KEY_ID']
ENV['AWS_S3_SECRET_ACCESS_KEY']
ENV['CLOUDFRONT_URL']
```

`ENV['CLOUDFRONT_URL']` is optional, but if set will configure `config.asset_host` so CarrierWave will pull from your Cloudfront distribution.

## Mandrill ActionMailer Setup through ENV

When required, metova-rails will setup Rails' ActionMailer to send e-mail through Mandrill. To enable this configuration, add "metova/mandrill"
to the `require` array in your Gemfile:

`gem 'metova', require: ['metova/mandrill']`

Setting the following ENV variables will configure ActionMailer appropriately. Not setting `ENV['MANDRILL_DOMAIN']` will skip this configuration
which may be useful in the test/development environment.

```
ENV['MANDRILL_DOMAIN']
ENV['MANDRILL_DEFAULT_HOST']
ENV['MANDRILL_USERNAME']
ENV['MANDRILL_PASSWORD']
```

If `ENV['MANDRILL_DEFAULT_HOST']` is not set, `ENV['MANDRILL_DOMAIN']` will be used instead for `default_url_options`.

## Contributing

1. Fork it ( https://github.com/metova/metova-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. **Add Tests**
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
