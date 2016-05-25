ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/rails'
require 'shoulda/matchers'
require 'factory_girl_rails'
require 'ffaker'
require 'database_cleaner'
require 'headless'

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_server :thin do |app, port|
  require 'rack/handler/thin'
  Rack::Handler::Thin.run(app, Port: port)
end


Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs_options: ['--load-images=no'])
end

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.default_max_wait_time = 20
  config.match = :one
  config.exact_options = true
  config.ignore_hidden_elements = true
  config.visible_text_only = true
  config.default_selector = :css
end

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f }
Dir[Rails.root.join('spec/support/features/**/*.rb')].sort.each {|f| require f }


RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods

  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
    FileUtils.rm_rf(Rails.configuration.attachments_dir)
  end
end
