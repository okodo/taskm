Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.attachments_dir = Rails.root.join('public/system')
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default charset: 'utf-8'
  config.action_mailer.default_url_options = { host: 'localhost', port: '3000', protocol: 'http' }
  config.action_mailer.asset_host = 'http://localhost:3000'
  config.mailers_default_from = 'info@valucon-coding.de'
end