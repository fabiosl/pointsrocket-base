# require 'rack-timer'

if ENV['DB_LOGS'] == 'false'
  ActiveRecord::Base::logger = nil
end

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. fThis slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  # config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  if ENV['ASSET_HOST'].present?
    config.action_controller.asset_host = ENV['ASSET_HOST']
  end

  if ENV['DEVELOPMENT_ASSETS_PRECOMPILE'] == 'true'
    # Disable Rails's static asset server (Apache or nginx will already do this).
    # config.serve_static_assets = false

    # Compress JavaScripts and CSS.
    config.assets.js_compressor = :uglifier
    config.assets.css_compressor = :sass

    # Do not fallback to assets pipeline if a precompiled asset is missed.
    config.assets.compile = false

    # Generate digests for assets URLs.
    config.assets.digest = true
  end
  config.assets.debug = true

  # config.middleware.insert_before 0, "RackTimer::Middleware"

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.time_zone = 'Brasilia'
end