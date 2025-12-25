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
        I18n.available_locales
      end

    scope = member_id ? Member.where(id: member_id) : Member.all
    total = scope.count

    puts 'Starting normalization of member translations...'
    puts "Dry run: #{dry_run}"
    puts "Locales: #{locales.join(', ')}"
    puts "ChatGPT API Key configured: #{GptSettings.key.present? ? 'YES' : 'NO'}"
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

      # Normalize EN if present (useful fallback source).
      en_t = member.translations.find_by(locale: 'en')
      if en_t
        fields.each do |field|
          en_before = en_t.public_send(field).to_s
          next if en_before.blank?

          en_after = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(en_before))
          next if en_after.strip == en_before.strip

          if dry_run
            puts "  - en/#{field}: WOULD CLEAN"
          else
            t = member.translations.find_or_initialize_by(locale: 'en')
            t[field] = en_after
            required_fields.each do |req_field|
              next if t[req_field].present?

              t[req_field] = en_t.public_send(req_field).presence ||
                             member.translations.where.not(req_field => [nil, '']).first&.public_send(req_field)
            end
            t.save!
            puts "  - en/#{field}: cleaned"
          end
        rescue StandardError => e
          errors += 1
          puts "  - en/#{field}: ERROR #{e.class}: #{e.message}"
        end
      end

      # Ensure/normalize PL:
      # - If PL exists: normalize it.
      # - If PL missing but EN exists: create PL by translating from EN.
      pl_t = member.translations.find_by(locale: 'pl')
      if pl_t
        fields.each do |field|
          pl_before = pl_t.public_send(field).to_s
          next if pl_before.blank?

          pl_after = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(pl_before))
          next if pl_after.strip == pl_before.strip

          if dry_run
            puts "  - pl/#{field}: WOULD CLEAN"
          else
            t = member.translations.find_or_initialize_by(locale: 'pl')
            t[field] = pl_after
            required_fields.each do |req_field|
              next if t[req_field].present?

              t[req_field] = pl_t.public_send(req_field).presence ||
                             member.translations.where.not(req_field => [nil, '']).first&.public_send(req_field)
            end
            t.save!
            puts "  - pl/#{field}: cleaned"
          end
        rescue StandardError => e
          errors += 1
          puts "  - pl/#{field}: ERROR #{e.class}: #{e.message}"
        end
      elsif en_t
        if dry_run
          puts '  - pl: WOULD CREATE FROM EN'
        else
          t = member.translations.find_or_initialize_by(locale: 'pl')
          fields.each do |field|
            base_html = TextTranslationNormalizer.call(
              HtmlTranslationNormalizer.call(en_t.public_send(field).to_s)
            )
            next if base_html.blank?

            repaired = service.call(
              base_html:,
              base_locale: :en,
              current_target_html: '',
              target_locale: :pl
            )
            repaired = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(repaired))
            t[field] = repaired
          end

          required_fields.each do |req_field|
            next if t[req_field].present?

            t[req_field] = en_t.public_send(req_field).presence
          end

          t.save!
          puts '  - pl: created from EN'
          changed += 1
        end
      else
        puts '  - SKIP: missing base PL and EN translations'
        skipped += 1
        next
      end

      base_locale = member.translations.find_by(locale: 'pl') ? :pl : :en
      base_translation = member.translations.find_by(locale: base_locale.to_s)
      if base_translation.nil?
        puts "  - SKIP: missing base #{base_locale.to_s.upcase} translation"
        skipped += 1
        next
      end

      # If user explicitly asked for PL, we're done (PL ensured/normalized above).
      if target_locale == :pl
        puts '  - pl: ok'
        next
      end

      locales.each do |locale|
        next if locale == :pl
        next if locale == base_locale

        fields.each do |field|
          base_value = TextTranslationNormalizer.call(
            HtmlTranslationNormalizer.call(base_translation.public_send(field).to_s)
          )
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
