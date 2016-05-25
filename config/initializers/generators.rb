Rails.application.config.generators do |g|
  g.test_framework :rspec, fixture: true
  g.fixture_replacement :factory_girl, dir: 'spec/factories'

  g.helper = false

  g.view_specs false
  g.helper_specs false
  g.assets = false
end
