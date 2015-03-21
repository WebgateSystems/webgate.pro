# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'webgate.pro'
set :deploy_user, 'webgate'
set :repo_url, 'git@tracker.webgate.pro:internal/webgate.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

set :tests, []

# Default value for :pty is false
# set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/assets public/uploads}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  task :restart do
    invoke 'unicorn:reload'
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
