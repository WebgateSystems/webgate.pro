require File.expand_path('boot', __dir__)

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

require 'active_model/railtie'
require 'active_job/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module WebgatePro
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    ActiveRecord.legacy_connection_handling = false

    config.autoload_paths << Rails.root.join('lib')

    config.i18n.enforce_available_locales = true
    # I18n.config.enforce_available_locales = true
    config.i18n.available_locales = %i[pl en ru fr ua]
    config.i18n.fallbacks = true

    config.generators do |g|
      g.template_engine :slim
      g.test_framework :rspec, fixtures: true, views: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.exceptions_app = routes
  end
end
