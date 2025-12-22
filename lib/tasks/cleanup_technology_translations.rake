# rubocop:disable Metrics/BlockLength
namespace :technologies do
  desc 'Clean technology translations (strip quotes, remove styles/classes/ids). ' \
       'Usage: rake technologies:cleanup_translations[technology_id,locale,dry_run]'
  task :cleanup_translations, %i[technology_id locale dry_run] => :environment do |_t, args|
    technology_id = args[:technology_id].presence
    target_locale = args[:locale].presence&.to_sym
    dry_run = args[:dry_run].to_s == 'true'

    locales =
      if target_locale
        [target_locale]
      else
        I18n.available_locales
      end

    scope = technology_id ? Technology.where(id: technology_id) : Technology.all
    total = scope.count

    puts 'Starting cleanup of technology translations...'
    puts "Dry run: #{dry_run}"
    puts "Locales: #{locales.join(', ')}"
    puts ''

    processed = 0
    changed = 0
    errors = 0

    scope.find_each do |tech|
      processed += 1
      puts "[#{processed}/#{total}] Technology ID: #{tech.id} (#{tech.title})"

      locales.each do |locale|
        I18n.with_locale(locale) do
          before_desc = tech.description.to_s
          before_link = tech.link.to_s

          after_desc = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(before_desc))
          after_link = TextTranslationNormalizer.call(before_link)
          after_link = before_link if after_link.blank?

          next if after_desc == before_desc && after_link == before_link

          if dry_run
            changed += 1
            puts "  - #{locale}: WOULD CLEAN"
            next
          end

          t = tech.translations.find_or_initialize_by(locale: locale.to_s)
          t.description = after_desc
          t.link = after_link
          t.save!
          changed += 1
          puts "  - #{locale}: cleaned"
        end
      rescue StandardError => e
        errors += 1
        puts "  - #{locale}: ERROR #{e.class}: #{e.message}"
      end
    end

    puts "\nDone. Processed: #{processed}, changed: #{changed}, errors: #{errors}"
  end
end
# rubocop:enable Metrics/BlockLength
