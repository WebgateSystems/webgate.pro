# Set secret_key_base from Settings if available, otherwise fallback to ENV
# This allows centralizing secret_key_base configuration in one place (config/settings.yml)
# instead of duplicating it in each environment file.
# Note: config/secrets.yml is deprecated in Rails 7 and not used by this application.
# In test environment, if secret_key_base is not set, Rails will generate it automatically.
#
# This initializer is loaded after config.rb (alphabetically), so Settings should be available.
# We use after_initialize to ensure Settings is fully loaded by the config gem.
Rails.application.config.after_initialize do
  if defined?(Settings) && Settings.respond_to?(:secret_key_base) && Settings.secret_key_base.present?
    Rails.application.config.secret_key_base = Settings.secret_key_base
  elsif ENV['SECRET_KEY_BASE'].present?
    Rails.application.config.secret_key_base = ENV['SECRET_KEY_BASE']
  elsif ENV['secret_key_base'].present?
    Rails.application.config.secret_key_base = ENV['secret_key_base']
  end
  # If secret_key_base is still not set (e.g., in test environment), Rails will generate it automatically
end
