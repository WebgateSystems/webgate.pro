Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.quiet = true
  config.assets.enabled = true

  config.assets.css_compressor = :yui
  config.assets.js_compressor = Uglifier.new(harmony: true)

  config.active_job.queue_adapter = :sidekiq

  # config.assets.compress = true
  # config.assets.compile = true
  # config.assets.digest = true
  # config.serve_static_assets = false
  # config.assets.js_compressor  = :uglifier
  # config.assets.css_compressor = :yui

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # config.active_record.raise_in_transactional_callbacks = true

  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = false
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = false
  end
end
