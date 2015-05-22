# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'webgate.pro'
set :deploy_user, 'webgate'
set :repo_url, 'git@tracker.webgate.pro:internal/webgate.git'

set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

set :tests, []

# Default value for :pty is false
# set :pty, true

set :linked_files, %w{config/database.yml config/config.yml config/sidekiq.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/assets public/uploads}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do

  desc "Run the save_members_technologies rake task"
  task :save_members_technologies do
    on roles(:web) do
      rails_env = fetch(:rails_env, 'staging')
      execute "~/.rvm/scripts/rvm && cd #{current_path} && rake db:save_members_technologies RAILS_ENV=#{rails_env}"
    end
  end

  desc "Run the save_projects_technologies rake task"
  task :save_projects_technologies do
    on roles(:web) do
      rails_env = fetch(:rails_env, 'staging')
      execute "~/.rvm/scripts/rvm && cd #{current_path} && rake db:save_projects_technologies RAILS_ENV=#{rails_env}"
    end
  end

  desc "Run the load_members_technologies rake task"
  task :load_members_technologies do
    on roles(:web) do
      rails_env = fetch(:rails_env, 'staging')
      execute "~/.rvm/scripts/rvm && cd #{current_path} && rake db:load_members_technologies RAILS_ENV=#{rails_env}"
    end
  end

  desc "Run the load_projects_technologies rake task"
  task :load_projects_technologies do
    on roles(:web) do
      rails_env = fetch(:rails_env, 'staging')
      execute "~/.rvm/scripts/rvm && cd #{current_path} && rake db:load_projects_technologies RAILS_ENV=#{rails_env}"
    end
  end

  before :starting, 'save_members_technologies'
  before :starting, 'save_projects_technologies'
  after :finishing, 'load_members_technologies'
  after :finishing, 'load_projects_technologies'

  task :restart do
    invoke 'unicorn:restart'
  end
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
