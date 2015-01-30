source 'https://rubygems.org'

gem 'rails', '~> 4.1.8'
gem 'pg'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-fileupload-rails'
gem 'slim-rails'
gem 'carrierwave'
gem 'mini_magick'
gem 'geoip'
gem 'russian'
gem 'globalize'
gem 'rails-translate-routes'
gem 'exception_notification'
gem 'unicorn'
gem 'kaminari'
gem 'faker'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 1.2'
gem 'json'
gem 'sorcery'
gem 'foundation-rails'
gem 'simple_form'
gem 'cocoon'
gem 'chosen-rails'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  # gem 'sdoc', require: false
end

group :prodaction do
  gem 'rails_12factor'
  gem 'rails_serve_static_assets'
end

group :development do
  gem 'thin'
  # Deploy with Capistrano
  gem 'capistrano', '2.15.5'
  gem 'cape'                                                                
  gem 'capistrano-unicorn'                                                  
  gem 'capistrano-ext'                                                      
  gem 'capistrano_colors'                                                   
  gem 'rvm-capistrano'
  gem 'rack-mini-profiler', '~> 0.9.2'
  # Better errors handler
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'timecop'
  gem 'spork'
  gem 'launchy'
  gem 'simplecov'

  #gem 'mocha'
end

group :test, :development do
  # gem 'webrat'
  gem 'rspec-rails'
  gem 'hpricot'
  gem 'ruby_parser'
  #gem 'debugger'
  gem 'byebug'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'
