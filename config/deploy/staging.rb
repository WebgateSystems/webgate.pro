set :stage, :staging
set :branch, "feature/issue_48"

set :full_app_name, "test.webgate.pro"
set :server_name, "#{fetch(:full_app_name)}"

server "#{fetch(:server_name)}", user: "#{fetch(:deploy_user)}", roles: %w{web app db}, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:full_app_name)}"

set :rails_env, :staging
