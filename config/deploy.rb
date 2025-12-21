# config valid only for current version of Capistrano
lock '3.18.1'

set :ssh_options, { forward_agent: true, port: 39_168 }
set :application, 'webgate.pro'
set :deploy_user, 'webgate'
set :repo_url, 'git@github.com:WebgateSystems/webgate.pro.git'
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info
set :tests, []
set :linked_files, %w[config/database.yml config/config.yml config/sidekiq.yml public/robots.txt]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets public/assets public/uploads public/sitemaps]
set :whenever_identifier, -> { fetch(:deploy_user).to_s }

set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
after 'deploy:finishing', 'spec:check_links'

desc 'Invoke a rake command on the remote server' # example: cap staging "invoke[db:seed]"
task :invoke, [:command] => 'deploy:set_rails_env' do |_task, args|
  on primary(:app) do
    within current_path do
      with rails_env: fetch(:rails_env) do
        rake args[:command]
      end
    end
  end
end

namespace :deploy do
  task :restart do
    on roles(:web) do
      execute("~#{fetch(:deploy_user)}/bin/#{fetch(:stage)}.sh", :restart)
    end
  end
end
