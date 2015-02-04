# Set your full path to application.
app_path = "/home/webgate/test.webgate.pro/current"
shared_path = "/home/webgate/test.webgate.pro/shared"

set :domain, "test.webgate.pro"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

server "test.webgate.pro", :app, :web, :db, :primary => true

set :shared_host, "test.webgate.pro"
set :branch, "staging"
set :unicorn_env, "staging"
set :unicorn_pid, "#{app_path}/tmp/pids/unicorn.pid"
set :deploy_to, "/home/webgate/test.webgate.pro/"
