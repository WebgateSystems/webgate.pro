# rubocop:disable Metrics/BlockLength
namespace :projects do
  desc 'Repair/normalize project content translations. ' \
       'Usage: rake projects:normalize_translations[project_id,locale,dry_run]'
  task :normalize_translations, %i[project_id locale dry_run] => :environment do |_t, args|
    project_id = args[:project_id].presence
    target_locale = args[:locale].presence&.to_sym
    dry_run = args[:dry_run].to_s == 'true'

    locales =
      if target_locale
        [target_locale]
      else
        I18n.available_locales - [:pl]
      end

    scope = project_id ? Project.where(id: project_id) : Project.all
    total = scope.count

    puts 'Starting normalization of project translations...'
    puts "Dry run: #{dry_run}"
    puts "Locales: #{locales.join(', ')}"
    puts "ChatGPT API Key configured: #{GptSettings.key.present? ? 'YES' : 'NO'}"
    puts ''

    service = GptTranslationRepairService.new
    processed = 0
    changed = 0
    skipped = 0
    errors = 0

    scope.find_each do |project|
      processed += 1
      puts "[#{processed}/#{total}] Project ID: #{project.id}"

      base_locale = project.translations.find_by(locale: 'pl') ? :pl : :en
      base_translation = project.translations.find_by(locale: base_locale.to_s)
      base_content = base_translation&.content.to_s

      if base_content.blank?
        puts "  - SKIP: missing base #{base_locale.to_s.upcase} content"
        skipped += 1
        next
      end

      # Always normalize base locale itself (remove styles/quotes artifacts)
      base_before = base_content
      base_after = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(base_before))
      if base_after.strip != base_before.to_s.strip
        if dry_run
          puts "  - #{base_locale}: WOULD CLEAN BASE"
        else
          base_t = project.translations.find_or_initialize_by(locale: base_locale.to_s)
          base_t.title = base_t.title.presence || project.translations.where.not(title: [nil, '']).first&.title
          base_t.content = base_after
          base_t.save!
          puts "  - #{base_locale}: cleaned base"
        end
      end

      locales.each do |locale|
        next if locale == base_locale

        current = project.translations.find_by(locale: locale.to_s)&.content.to_s
        repaired = service.call(
          base_html: base_after,
          base_locale:,
          current_target_html: current,
          target_locale: locale
        )

        repaired = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(repaired))
        current_clean = TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(current))

        base_title = base_translation&.title

        if repaired.strip == current_clean.strip
          puts "  - #{locale}: ok"
          next
        end

        if dry_run
          puts "  - #{locale}: WOULD UPDATE"
          changed += 1
          next
        end

        t = project.translations.find_or_initialize_by(locale: locale.to_s)
        t.title = t.title.presence || base_title.presence || project.translations.where.not(title: [nil,
                                                                                                    '']).first&.title
        t.content = repaired
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

    unless dry_run
      puts "\nExpiring cache for projects page..."
      Rake::Task['cache:expire_projects'].reenable
      Rake::Task['cache:expire_projects'].invoke
    end
  end
end
# rubocop:enable Metrics/BlockLength
