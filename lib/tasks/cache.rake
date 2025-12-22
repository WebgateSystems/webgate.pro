# rubocop:disable Metrics/BlockLength
namespace :cache do
  desc 'Clear Rails cache'
  task clear: :environment do
    puts 'Clearing Rails cache...'
    Rails.cache.clear
    puts '✓ Cache cleared!'
  end

  desc 'Expire cache for members page'
  task expire_members: :environment do
    puts 'Expiring cache for members page...'
    helper = Object.new.extend(HomeHelper)
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        cache_key = helper.cache_key_for_members
        Rails.cache.delete([cache_key, { locale: }])
        puts "  Expired cache for locale: #{locale}"
      end
    end
    puts '✓ Members cache expired!'
  end

  desc 'Expire cache for projects page'
  task expire_projects: :environment do
    puts 'Expiring cache for projects page...'
    helper = Object.new.extend(HomeHelper)
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        cache_key = helper.cache_key_for_projects
        Rails.cache.delete([cache_key, { locale: }])
        puts "  Expired cache for locale: #{locale}"
      end
    end
    puts '✓ Projects cache expired!'
  end

  desc 'Expire all page caches'
  task expire_all: :environment do
    puts 'Expiring all page caches...'
    # Ensure nested invocations run even if these tasks were invoked earlier in the same process
    Rake::Task['cache:expire_members'].reenable
    Rake::Task['cache:expire_members'].invoke
    Rake::Task['cache:expire_projects'].reenable
    Rake::Task['cache:expire_projects'].invoke
    puts '✓ All caches expired!'
  end
end
# rubocop:enable Metrics/BlockLength
