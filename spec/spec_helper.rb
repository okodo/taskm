require 'simplecov'
require 'webmock'

SimpleCov.minimum_coverage 92
SimpleCov.start 'rails' do
  # add_filter 'app/admin'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
end
