require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
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
    config.i18n.enforce_available_locales = true
    #I18n.config.enforce_available_locales = true
    config.i18n.available_locales = [:pl, :en, :ru, :fr]
    config.i18n.fallbacks = true

    config.generators do |g|
      g.template_engine :slim
      g.test_framework :rspec, fixtures: true, views: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    if Rails.env.production? or Rails.env.staging?
      config.before_configuration  do
        env_file = File.join(Rails.root, 'config', 'config.yml')
        YAML.load(File.open(env_file))[Rails.env].each do |key, value|
          ENV[key] = value.to_s
        end if File.exists?(env_file)
        YAML.load(File.open(env_file))[Rails.env]['notify_smtp_data'].each do |key, value|
          ENV[key] = value.to_s
        end if File.exists?(env_file)
      end
    end

  end
end
