require 'capistrano_colors'
require 'rvm/capistrano'                  # Load RVM's capistrano plugin.
require 'bundler/capistrano'              # Capistrano task for Bundler.
require 'cape'
require 'capistrano/ext/multistage'
require 'capistrano-unicorn'

set :rvm_type, :user
set :rvm_ruby_string, :release_path

set :stages, [:staging, :production]
set :default_stage, :production

set :rails_env, "staging"
set :user, "webgate"
set :runner, user
set :scm, :git
set :scm_username, "sysadm"
set :application, "webgate"
set :repository, "git@bitbucket.org:#{scm_username}/#{application}.git"
#ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/id_dsa"]

set :keep_releases, 5
set :use_sudo, false
set :git_shallow_clone, 1
set :deploy_via, :remote_cache
set :shared_children, shared_children + %w(public/uploads)

default_run_options[:pty] = true

before 'deploy:assets:precompile', 'deploy:symlink_shared'
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:symlink_shared', 'deploy:migrate'
after 'deploy', 'deploy:cleanup'
after 'deploy:assets:force_compile', 'unicorn:restart'

namespace :deploy do
  task :symlink_shared do
    run "ln -nsf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  namespace :assets do
    task :force_compile do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end

    #task :precompile, :roles => :web, :except => { :no_release => true } do
    #  # Check if assets have changed. If not, don't run the precompile task - it takes a long time.
    #  force_compile = false
    #  changed_asset_count = 0
    #  begin
    #    from = source.next_revision(current_revision)
    #    asset_locations = 'app/assets/ lib/assets vendor/assets'
    #    changed_asset_count = capture("cd #{latest_release} && #{source.local.log(from)} #{asset_locations} | wc -l").to_i
    #  rescue Exception => e
    #    logger.info "Error: #{e}, forcing precompile"
    #    force_compile = false
    #  end
    #  if changed_asset_count > 0 || force_compile
    #    logger.info "#{changed_asset_count} assets have changed. Pre-compiling"
    #    run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    #  else
    #    logger.info "#{changed_asset_count} assets have changed. Skipping asset pre-compilation"
    #  end
    #end
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    unicorn.restart
  end
  task :start, :roles => :app do
    unicorn.start
  end
  task :stop, :roles => :app do
    unicorn.stop
  end
end
