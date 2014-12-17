ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../spec/dummy/db/migrate", __FILE__)]

require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

module JSONHelper
  def json
    _json = JSON[response.body]
    case _json
    when Array
      _json.map(&:with_indifferent_access)
    when Hash
      _json.with_indifferent_access
    else
      _json
    end
  end
end


RSpec.configure do |config|
  config.global_fixtures = :all
  config.fixture_path = File.expand_path("../fixtures", __FILE__)
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include JSONHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before do
    @request.try { |req| req.env['HTTP_ACCEPT'] = 'application/json' }
  end

end