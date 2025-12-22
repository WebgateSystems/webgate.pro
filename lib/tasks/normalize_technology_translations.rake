# rubocop:disable Metrics/BlockLength
namespace :technologies do
  desc 'Repair/normalize technology descriptions via GPT (PL/EN base + current locale). ' \
       'Usage: rake technologies:normalize_descriptions[technology_id,locale,dry_run]'
  task :normalize_descriptions, %i[technology_id locale dry_run] => :environment do |_t, args|
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

    puts 'Starting normalization of technology descriptions...'
    puts "Dry run: #{dry_run}"
    puts "Locales: #{locales.join(', ')}"
    puts "ChatGPT API Key configured: #{Settings.gpt_key.present? ? 'YES' : 'NO'}"
    puts ''

    service = GptTranslationRepairService.new
    processed = 0
    changed = 0
    skipped = 0
    errors = 0

    scope.find_each do |tech|
      processed += 1
      puts "[#{processed}/#{total}] Technology ID: #{tech.id} (#{tech.title})"

      # Normalize EN if present (useful as a fallback source).
      en_t = tech.translations.find_by(locale: 'en')
      if en_t&.description.present?
        en_before = en_t.description.to_s
        en_after = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(en_before))
        if en_after.strip != en_before.strip
          if dry_run
            puts '  - en: WOULD CLEAN'
          else
            t = tech.translations.find_or_initialize_by(locale: 'en')
            t.link = t.link.presence || tech.translations.where.not(link: [nil, '']).first&.link
            t.description = en_after
            t.save!
            puts '  - en: cleaned'
          end
        end
      end

      # Ensure/normalize PL:
      # - If PL exists: normalize it.
      # - If PL missing but EN exists: create PL by translating from EN.
      pl_t = tech.translations.find_by(locale: 'pl')
      pl_desc = pl_t&.description.to_s

      if pl_desc.present?
        pl_after = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(pl_desc))
        if pl_after.strip != pl_desc.strip
          if dry_run
            puts '  - pl: WOULD CLEAN'
          else
            t = tech.translations.find_or_initialize_by(locale: 'pl')
            t.link = t.link.presence || tech.translations.where.not(link: [nil, '']).first&.link
            t.description = pl_after
            t.save!
            puts '  - pl: cleaned'
          end
        end
      elsif en_t&.description.present?
        en_desc_clean = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(en_t.description.to_s))
        if dry_run
          puts '  - pl: WOULD CREATE FROM EN'
        else
          repaired_pl = service.call(
            base_html: en_desc_clean,
            base_locale: :en,
            current_target_html: '',
            target_locale: :pl
          )
          repaired_pl = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(repaired_pl))

          t = tech.translations.find_or_initialize_by(locale: 'pl')
          t.link = t.link.presence || tech.translations.where.not(link: [nil, '']).first&.link
          t.description = repaired_pl
          t.save!
          puts '  - pl: created from EN'
          changed += 1
        end
      else
        puts '  - SKIP: missing base PL and EN descriptions'
        skipped += 1
        next
      end

      base_locale = tech.translations.find_by(locale: 'pl')&.description.present? ? :pl : :en
      base_translation = tech.translations.find_by(locale: base_locale.to_s)
      base_desc_clean = TextTranslationNormalizer.call(
        HtmlTranslationNormalizer.call(base_translation&.description.to_s)
      )

      # If user explicitly asked for PL, we're done.
      if target_locale == :pl
        puts '  - pl: ok'
        next
      end

      locales.each do |locale|
        next if locale == :pl
        next if locale == base_locale

        current_desc = tech.translations.find_by(locale: locale.to_s)&.description.to_s
        repaired = service.call(
          base_html: base_desc_clean,
          base_locale:,
          current_target_html: current_desc,
          target_locale: locale
        )
        repaired = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(repaired))
        current_clean = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(current_desc))

        if repaired.strip == current_clean.strip
          puts "  - #{locale}: ok"
          next
        end

        if dry_run
          changed += 1
          puts "  - #{locale}: WOULD UPDATE"
          next
        end

        t = tech.translations.find_or_initialize_by(locale: locale.to_s)
        fallback_link = base_translation&.link.presence ||
                        tech.translations.where.not(link: [nil, '']).first&.link
        t.link = t.link.presence || fallback_link
        t.description = repaired
        t.save!

        changed += 1
        puts "  - #{locale}: updated"
      rescue StandardError => e
        errors += 1
        puts "  - #{locale}: ERROR #{e.class}: #{e.message}"
      end
    rescue StandardError => e
      errors += 1
      puts "  - ERROR #{e.class}: #{e.message}"
    end

    puts "\nDone. Processed: #{processed}, changed: #{changed}, skipped: #{skipped}, errors: #{errors}"
  end
end
# rubocop:enable Metrics/BlockLength
