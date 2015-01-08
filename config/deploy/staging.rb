set :domain, "dev.webgate.pro"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

server "dev.webgate.pro", :app, :web, :db, :primary => true

set :shared_host, "webgate.pro"
set :branch, "develop"
set :unicorn_env, "staging"
set :deploy_to, "/home/webgate/dev.webgate.pro/"
require 'capistrano-unicorn'
