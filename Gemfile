source 'https://rubygems.org'

gem 'pg'
gem 'puma', '>= 6.4.3'
gem 'rails', '~> 7.0.8', '>= 7.0.8.7'

gem 'carrierwave', '~> 3.0', '>= 3.0.7'
gem 'exception_notification', '~> 4.0.1'
gem 'geoip'
gem 'globalize'
gem 'kaminari'
gem 'mini_magick', '~> 4.12'
gem 'pry'
gem 'rails-translate-routes'
gem 'route_translator', '~> 13.1.1'
gem 'russian'
gem 'slim-rails'

gem 'dotenv-rails'
gem 'easy_access_gpt', git: 'https://github.com/WebgateSystems/EasyAccessGPT.git', branch: 'main'
gem 'interactor'

gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'autoprefixer-rails'
gem 'chosen-rails'
# ckeditor has known XSS vulnerabilities (CVE-2023-4771, CVE-2024-24815, etc.)
# but no patch is available yet. Consider migrating to CKEditor 5 or another editor.
gem 'ckeditor', '>= 5.1.2'
gem 'cocoon'
gem 'config'
gem 'dynamic_sitemaps'
gem 'jbuilder'
gem 'json'
gem 'oga'
gem 'ranked-model'
gem 'redis'
gem 'rexml', '>= 3.3.9'
gem 'select2-rails'
gem 'sidekiq', '~> 6.5', '>= 6.5.10'
gem 'simple_form'
# sinatra is managed by sidekiq as a dependency
gem 'sorcery'
gem 'whenever', require: false

# Use SCSS for stylesheets
gem 'coffee-rails'
gem 'execjs'
gem 'sass-rails'
gem 'sprockets-rails'
# gem "therubyracer", "~> 0.12"
gem 'font-awesome-rails'
gem 'foundation-rails', '~> 5.5.1'
gem 'uglifier'
gem 'yui-compressor'

gem 'jquery-fileupload-rails'
gem 'jquery-minicolors-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails', '>= 8.0.0'

group :development do
  gem 'bundler-audit'
  gem 'fasterer', require: false
  gem 'i18n-tasks', '~> 1.0.13'
  gem 'letter_opener'
  gem 'rack-mini-profiler'
  gem 'rubocop', require: false
  gem 'rubocop-i18n', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  # Deploy with Capistrano
  gem 'bullet'
  gem 'cape'
  gem 'capistrano-hook', require: false
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  # gem 'capistrano-sidekiq'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'rails-controller-testing'

  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov'
  gem 'spork'
  gem 'timecop'
end

group :test, :development do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'ruby_parser'
end
