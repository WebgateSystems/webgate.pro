# rubocop:disable Metrics/BlockLength
namespace :members do
  desc 'Repair/normalize member translations (PL/EN base + current locale). ' \
       'Usage: rake members:normalize_translations[member_id,locale,dry_run]'
  task :normalize_translations, %i[member_id locale dry_run] => :environment do |_t, args|
    member_id = args[:member_id].presence
    target_locale = args[:locale].presence&.to_sym
    dry_run = args[:dry_run].to_s == 'true'

    locales =
      if target_locale
        [target_locale]
      else
        I18n.available_locales - [:pl]
      end

    scope = member_id ? Member.where(id: member_id) : Member.all
    total = scope.count

    puts 'Starting normalization of member translations...'
    puts "Dry run: #{dry_run}"
    puts "Locales: #{locales.join(', ')}"
    puts "ChatGPT API Key configured: #{Settings.gpt_key.present? ? 'YES' : 'NO'}"
    puts ''

    service = GptTranslationRepairService.new
    processed = 0
    changed = 0
    skipped = 0
    errors = 0

    fields = %i[name job_title description motto education]
    required_fields = %i[name job_title description motto]

    scope.find_each do |member|
      processed += 1
      puts "[#{processed}/#{total}] Member ID: #{member.id}"

      base_locale = member.translations.find_by(locale: 'pl') ? :pl : :en
      base_translation = member.translations.find_by(locale: base_locale.to_s)
      if base_translation.nil?
        puts "  - SKIP: missing base #{base_locale.to_s.upcase} translation"
        skipped += 1
        next
      end

      # Always normalize base locale itself (update translation row directly to avoid parent validations)
      fields.each do |field|
        base_before = base_translation.public_send(field).to_s
        next if base_before.blank?

        base_after = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(base_before))
        next if base_after.strip == base_before.strip

        if dry_run
          puts "  - #{base_locale}/#{field}: WOULD CLEAN BASE"
        else
          t = member.translations.find_or_initialize_by(locale: base_locale.to_s)
          t[field] = base_after
          required_fields.each do |req_field|
            next if t[req_field].present?

            t[req_field] = base_translation.public_send(req_field).presence ||
                           member.translations.where.not(req_field => [nil, '']).first&.public_send(req_field)
          end
          t.save!
          puts "  - #{base_locale}/#{field}: cleaned base"
        end
      rescue StandardError => e
        errors += 1
        puts "  - #{base_locale}/#{field}: ERROR #{e.class}: #{e.message}"
      end

      locales.each do |locale|
        next if locale == base_locale

        fields.each do |field|
          base_value = base_translation.public_send(field).to_s
          current_value = member.translations.find_by(locale: locale.to_s)&.public_send(field).to_s

          next if base_value.blank? && current_value.blank?

          repaired = service.call(
            base_html: base_value,
            base_locale:,
            current_target_html: current_value,
            target_locale: locale
          )
          repaired = HtmlTranslationNormalizer.call(repaired)
          repaired = TextTranslationNormalizer.call(repaired)

          current_clean = HtmlTranslationNormalizer.call(current_value)
          current_clean = TextTranslationNormalizer.call(current_clean)

          next if repaired.strip == current_clean.strip

          if dry_run
            changed += 1
            puts "  - #{locale}/#{field}: WOULD UPDATE"
            next
          end

          t = member.translations.find_or_initialize_by(locale: locale.to_s)
          t[field] = repaired.presence || base_value
          required_fields.each do |req_field|
            next if t[req_field].present?

            t[req_field] = base_translation.public_send(req_field).presence ||
                           member.translations.where.not(req_field => [nil, '']).first&.public_send(req_field)
          end
          t.save!

          changed += 1
          puts "  - #{locale}/#{field}: updated"
        rescue StandardError => e
          errors += 1
          puts "  - #{locale}/#{field}: ERROR #{e.class}: #{e.message}"
        end
      end
    rescue StandardError => e
      errors += 1
      puts "  - ERROR #{e.class}: #{e.message}"
    end

    puts "\nDone. Processed: #{processed}, changed: #{changed}, skipped: #{skipped}, errors: #{errors}"

    unless dry_run
      puts "\nExpiring cache for members page..."
      Rake::Task['cache:expire_members'].reenable
      Rake::Task['cache:expire_members'].invoke
    end
  end
end
# rubocop:enable Metrics/BlockLength
