# Set your full path to application.
app_path = "/home/webgate/webgate.pro/current"
shared_path = "/home/webgate/webgate.pro/shared"

set :domain, "webgate.pro"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

server "webgate.pro", :app, :web, :db, :primary => true

set :shared_host, "webgate.pro"
set :branch, "master"
set :unicorn_env, "production"
set :unicorn_pid, "#{app_path}/tmp/pids/unicorn.pid"
set :deploy_to, "/home/webgate/#{application}/"
