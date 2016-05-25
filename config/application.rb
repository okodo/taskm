require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Taskm
  class Application < Rails::Application

    config.active_record.raise_in_transactional_callbacks = true
    config.time_zone = 'Moscow'
    config.i18n.default_locale = :ru
    config.i18n.available_locales = :ru

    # Minimum Sass number precision required by bootstrap-sass
    ::Sass::Script::Value::Number.precision = [8, ::Sass::Script::Value::Number.precision].max
    config.sass.preferred_syntax = :sass
    config.sass.syntax = :sass

    # Pepper for auth
    config.pepper = '071ae012df8b8269c876462c39ae49c39910d2915ed3b1cc8e329fe3da41c6aa39b4569719783cc74da3ae3b4c0453cb648d380de7364778ba22ed142735b1b1'

  end
end
