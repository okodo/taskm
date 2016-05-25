Rails.application.config.assets.version = '1.0'
# Bower asset paths
Rails.root.join('vendor', 'assets', 'bower_components').to_s.tap do |bower_path|
  Rails.application.config.sass.load_paths << bower_path
  Rails.application.config.assets.paths << bower_path
end
# Precompile Bootstrap fonts
Rails.application.config.assets.precompile << %r{bootstrap-sass/assets/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$}
Rails.application.config.assets.precompile << %r{font-awesome-sass/assets/fonts/font-awesome/[\w-]+\.(?:eot|otf|svg|ttf|woff2?)$}

Rails.application.config.assets.precompile += %w(turboloader.css)
Rails.application.config.assets.precompile += %w(checkboxes.css)
