require 'simplecov_helper'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

require 'capybara/rspec'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('app/uploaders/*.rb').to_s].each { |file| require file }
if defined?(CarrierWave)
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?

    klass.class_eval do
      if method_defined?(:cache_dir) && !method_defined?(:cache_dir_original)
        alias_method :cache_dir_original,
                     :cache_dir
      end
      if method_defined?(:store_dir) && !method_defined?(:store_dir_original)
        alias_method :store_dir_original,
                     :store_dir
      end

      def cache_dir
        Rails.root.join('public/spec/uploads/cache').to_s
      end

      def store_dir
        Rails.root.join("public/spec/uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}").to_s
      end
    end
  end
end

# Suppress ImageMagick deprecation warnings in tests
if Rails.env.test?
  Warning[:deprecated] = false

  # With :imagemagick7 CLI configured in carrierwave.rb, MiniMagick should use 'magick' command
  # which doesn't produce deprecation warnings. If warnings still appear from ImageMagick,
  # they can be safely ignored in test environment as they don't affect functionality.
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  # Capybara.default_wait_time = 10

  # config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL, type: :feature
  config.include Select2Helper, type: :feature

  config.include Sorcery::TestHelpers::Rails::Controller, type: :request

  config.include Sorcery::TestHelpers::Rails::Controller, type: :controller
  config.include Sorcery::TestHelpers::Rails::Integration, type: :feature

  config.include ChosenSelect
  config.include MailerMacros

  config.before :each, :js, type: :feature do |example|
    if example.metadata[:js] && (Capybara.javascript_driver == :webkit)
      page.driver.block_unknown_urls
      # page.driver.allow_url('api.stripe.com')
    end
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir[Rails.root.join('public/spec').to_s]) if Rails.env.test? || Rails.env.cucumber?
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join('spec/fixtures').to_s

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.infer_spec_type_from_file_location!
end
