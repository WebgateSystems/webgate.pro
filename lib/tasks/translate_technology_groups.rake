# rubocop:disable Metrics/BlockLength
namespace :technology_groups do
  desc 'Translate all technology groups to missing locales using Polish as base. ' \
       'Usage: rake technology_groups:translate_missing[technology_group_id,locale]'
  task :translate_missing, %i[technology_group_id locale] => :environment do |_t, args|
    technology_group_id = args[:technology_group_id]&.to_i
    locale = args[:locale]&.to_sym

    puts "ChatGPT API Key configured: #{GptSettings.key.present? ? 'YES' : 'NO'}"
    puts "Available locales: #{I18n.available_locales.join(', ')}"
    puts ''

    scope = technology_group_id ? TechnologyGroup.where(id: technology_group_id) : TechnologyGroup.all
    total = scope.count
    processed = 0
    errors = 0

    scope.find_each do |group|
      processed += 1
      puts "[#{processed}/#{total}] Processing technology_group ID: #{group.id}"

      begin
        current_locale = I18n.locale
        I18n.locale = :pl

        result =
          if locale
            unless I18n.available_locales.include?(locale)
              puts "  ✗ Error: Invalid locale '#{locale}'. Available locales: #{I18n.available_locales.join(', ')}"
              exit 1
            end
            TechnologyGroupTranslation.call(model: group, current_locale:, force_locale: locale)
          else
            TechnologyGroupTranslation.call(model: group, current_locale:)
          end

        if result.failure?
          puts "  ✗ Interactor failed: #{result.error}"
          errors += 1
        else
          group.reload
          base_tr = group.translations.find_by(locale: 'pl') || group.translations.first
          require_desc = base_tr&.description.present?
          missing = I18n.available_locales.reject do |loc|
            tr = group.translations.find_by(locale: loc.to_s)
            next false unless tr.present? && tr.title.present?

            require_desc ? tr.description.present? : true
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
        Rails.logger.error "Translation failed for technology_group #{group.id}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      ensure
        I18n.locale = current_locale if current_locale
      end

      puts ''
    end

    puts "\n#{'=' * 50}"
    puts 'Translation complete!'
    puts "Processed: #{processed} technology groups"
    puts "Errors: #{errors} technology groups"
    puts '=' * 50
  end
end
# rubocop:enable Metrics/BlockLength
