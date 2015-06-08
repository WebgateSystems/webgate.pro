namespace :spec do
  desc 'Check links'
  task :check_links do
    on primary(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          rake 'spec:check_links'
        end
      end
    end
  end
end
