namespace :sitemaps do
  desc 'Generate sitemaps'
  task generate: :environment do
    Rake::Task['sitemap:generate'].execute
  end
end
