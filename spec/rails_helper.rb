ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'selenium/webdriver'
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

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['intl.accept_languages'] = 'ru-RU'
  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile)
end

Capybara.configure do |config|
  config.javascript_driver = :selenium
  config.default_max_wait_time = 25
  config.match = :one
  config.exact_options = true
  config.ignore_hidden_elements = false
  config.visible_text_only = true
  config.default_selector = :css
end

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f }
Dir[Rails.root.join('spec/support/features/**/*.rb')].sort.each {|f| require f }


RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
  config.include Requests::AuthHelper, type: :controller
  config.include ::Angular::DSL

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.cleaning do
      FactoryGirl.lint
    end
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    FileUtils.rm_rf(Rails.configuration.attachments_dir)
  end

  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
end
