# Set secret_key_base from Settings if available (Settings is loaded after ENV)
# This allows centralizing secret_key_base configuration in one place (config/settings.yml)
# instead of duplicating it in each environment file.
# Note: config/secrets.yml is deprecated in Rails 7 and not used by this application.
# ENV variables are set in config/application.rb before_configuration hook.
# Settings is checked here after it's loaded by the config gem.
Rails.application.config.to_prepare do
  # Settings is now available, so we can override with Settings if present
  if defined?(Settings) && Settings.respond_to?(:secret_key_base) && Settings.secret_key_base.present?
    Rails.application.config.secret_key_base = Settings.secret_key_base
  end
  # If secret_key_base is still not set (e.g., in test environment), Rails will generate it automatically
end
