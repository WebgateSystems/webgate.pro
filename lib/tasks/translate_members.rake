# rubocop:disable Metrics/BlockLength
namespace :members do
  desc 'Translate all members to missing locales using Polish as base. ' \
       'Usage: rake members:translate_missing[member_id,locale]'
  task :translate_missing, %i[member_id locale] => :environment do |_t, args|
    member_id = args[:member_id]&.to_i
    locale = args[:locale]&.to_sym

    if member_id && locale
      # Translate specific member and locale
      puts "Translating member ID: #{member_id} to locale: #{locale}"
      puts "ChatGPT API Key configured: #{GptSettings.key.present? ? 'YES' : 'NO'}"
      puts ''

      member = Member.find_by(id: member_id)
      unless member
        puts "✗ Error: Member with ID #{member_id} not found"
        exit 1
      end

      unless I18n.available_locales.include?(locale)
        puts "✗ Error: Invalid locale '#{locale}'. Available locales: #{I18n.available_locales.join(', ')}"
        exit 1
      end

      begin
        current_locale = I18n.locale
        I18n.locale = :pl

        puts "Processing member ID: #{member.id}"
        puts '  Calling MemberTranslation interactor with force_locale...'
        result = MemberTranslation.call(model: member, current_locale:, force_locale: locale)

        if result.failure?
          puts "  ✗ Interactor failed: #{result.error}"
          exit 1
        else
          puts "  ✓ Translation for locale #{locale} completed"
        end
      rescue StandardError => e
        puts "  ✗ Error: #{e.class}: #{e.message}"
        puts "  Backtrace: #{e.backtrace.first(3).join("\n  ")}"
        Rails.logger.error "Translation failed for member #{member.id} to locale #{locale}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        exit 1
      ensure
        I18n.locale = current_locale if current_locale
      end

    else
      # Translate all members to missing locales (original behavior)
      puts 'Starting translation of members...'
      puts "ChatGPT API Key configured: #{GptSettings.key.present? ? 'YES' : 'NO'}"
      puts "Available locales: #{I18n.available_locales.join(', ')}"
      puts ''

      total_members = Member.count
      processed = 0
      errors = 0

      Member.find_each do |member|
        processed += 1
        puts "[#{processed}/#{total_members}] Processing member ID: #{member.id}"

        begin
          # Use Polish as base locale
          current_locale = I18n.locale
          I18n.locale = :pl

          puts '  Calling MemberTranslation interactor...'
          result = MemberTranslation.call(model: member, current_locale:)

          if result.failure?
            puts "  ✗ Interactor failed: #{result.error}"
            errors += 1
          else
            # Check which translations are still missing (check directly in DB, not via fallbacks)
            missing = I18n.available_locales.reject do |loc|
              translation = member.reload.translations.find_by(locale: loc.to_s)
              translation.present? && translation.name.present? && translation.description.present?
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
          Rails.logger.error "Translation failed for member #{member.id}: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
        ensure
          I18n.locale = current_locale if current_locale
        end

        puts '' # Empty line for readability
      end

      puts "\n#{'=' * 50}"
      puts 'Translation complete!'
      puts "Processed: #{processed} members"
      puts "Errors: #{errors} members"
      puts '=' * 50

      # Expire cache for members page after translations are updated
    end
    puts "\nExpiring cache for members page..."
    Rake::Task['cache:expire_members'].invoke
  end
end
# rubocop:enable Metrics/BlockLength
