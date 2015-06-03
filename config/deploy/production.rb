set :stage, :production
set :branch, 'master'

set :full_app_name, 'webgate.pro'
set :server_name, "#{fetch(:full_app_name)}"

server "#{fetch(:server_name)}", user: "#{fetch(:deploy_user)}", roles: %w(web app db), primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:full_app_name)}"

set :rails_env, :production
