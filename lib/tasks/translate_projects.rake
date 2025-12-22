# rubocop:disable Metrics/BlockLength
namespace :projects do
  desc 'Translate all projects to missing locales using Polish as base'
  task translate_missing: :environment do
    puts 'Starting translation of projects...'
    puts "ChatGPT API Key configured: #{Settings.gpt_key.present? ? 'YES' : 'NO'}"
    puts "Available locales: #{I18n.available_locales.join(', ')}"
    puts ''

    total_projects = Project.count
    processed = 0
    errors = 0

    Project.find_each do |project|
      processed += 1
      puts "[#{processed}/#{total_projects}] Processing project ID: #{project.id}"

      begin
        # Use Polish as base locale
        current_locale = I18n.locale
        I18n.locale = :pl

        puts '  Calling ProjectTranslation interactor...'
        result = ProjectTranslation.call(model: project, current_locale:)

        if result.failure?
          puts "  ✗ Interactor failed: #{result.error}"
          errors += 1
        else
          # Check which translations are still missing (check directly in DB, not via fallbacks)
          missing = I18n.available_locales.reject do |locale|
            translation = project.reload.translations.find_by(locale: locale.to_s)
            translation.present? && translation.content.present?
          end

          if missing.any?
            puts "  ⚠️  Still missing translations for: #{missing.join(', ')}"
          else
            puts '  ✓ All translations complete'
          end
        end
      rescue StandardError => e
        errors += 1
        puts "  ✗ Error: #{e.class}: #{e.message}"
        puts "  Backtrace: #{e.backtrace.first(3).join("\n  ")}"
        Rails.logger.error "Translation failed for project #{project.id}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      ensure
        I18n.locale = current_locale if current_locale
      end

      puts '' # Empty line for readability
    end

    puts "\n#{'=' * 50}"
    puts 'Translation complete!'
    puts "Processed: #{processed} projects"
    puts "Errors: #{errors} projects"
    puts '=' * 50

    # Expire cache for projects page after translations are updated
    puts "\nExpiring cache for projects page..."
    Rake::Task['cache:expire_projects'].invoke
  end
end
# rubocop:enable Metrics/BlockLength
