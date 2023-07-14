set :stage, :staging
set :branch, 'feature/code'

set :full_app_name, 'test.webgate.pro'
set :server_name, fetch(:full_app_name).to_s

server fetch(:server_name).to_s, user: fetch(:deploy_user).to_s, roles: %w[web app db], primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:full_app_name)}"

set :rails_env, :staging
