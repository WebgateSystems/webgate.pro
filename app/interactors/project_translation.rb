# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ProjectTranslation < BaseInteractor
  LOCALES = {
    de: 'German',
    en: 'English',
    fr: 'French',
    pl: 'Polish',
    ru: 'Russian',
    ua: 'Ukrainian'
  }.freeze

  # Base locale to use when translating missing translations
  BASE_LOCALE = :pl

  def call
    set_base_content
    find_missing_locales
    translate_missing_locales
    restore_original_locale
  end

  private

  def set_base_content
    if translation_exists?(BASE_LOCALE)
      assign_base_from_locale(BASE_LOCALE)
    else
      assign_base_from_available_locale
    end
  end

  def assign_base_from_locale(locale)
    @base_locale = locale
    I18n.with_locale(locale) do
      # We translate only `content`, but `title` is also translated and required by validations.
      # To avoid validation failures for missing locales, we reuse the base title.
      @base_content = {
        content: context.model.content,
        title: context.model.title
      }
    end
  end

  def assign_base_from_available_locale
    available_locale = I18n.available_locales.find { |l| translation_exists?(l) }
    if available_locale
      assign_base_from_locale(available_locale)
    else
      context.fail!(error: 'No base translation found')
    end
  end

  def find_missing_locales
    Rails.logger.debug "\nFinding missing locales and checking for duplicate translations..."
    @missing_locales = []
    @duplicate_locales = []

    I18n.available_locales.each do |locale|
      next if locale == @base_locale

      check_locale_status(locale)
    end

    Rails.logger.debug "Missing locales: #{@missing_locales.inspect}"
    Rails.logger.debug "Duplicate locales (will be deleted and retranslated): #{@duplicate_locales.inspect}"
  end

  def check_locale_status(locale)
    translation = context.model.translations.find_by(locale: locale.to_s)

    if missing_translation?(translation)
      add_missing_locale(locale)
    elsif translation_identical_to_base?(locale, translation)
      add_duplicate_locale(locale)
    else
      Rails.logger.debug "  #{locale}: EXISTS (unique)"
    end
  end

  def missing_translation?(translation)
    translation.nil? || translation.content.blank?
  end

  def add_missing_locale(locale)
    @missing_locales << locale
    Rails.logger.debug "  #{locale}: MISSING"
  end

  def add_duplicate_locale(locale)
    @duplicate_locales << locale
    Rails.logger.debug "  #{locale}: DUPLICATE (identical to #{@base_locale})"
  end

  def translation_identical_to_base?(_locale, translation)
    I18n.with_locale(@base_locale) do
      base_content = context.model.content
      translation_content = translation.content
      base_content.present? && translation_content.present? && base_content.strip == translation_content.strip
    end
  end

  def translation_exists?(locale)
    translation = context.model.translations.find_by(locale: locale.to_s)
    translation.present? && translation.content.present?
  end

  def translate_missing_locales
    delete_duplicate_translations
    return if @missing_locales.empty?

    Rails.logger.debug "\nProjectTranslation: Translating #{@missing_locales.count} missing locales"
    @missing_locales.each do |target_locale|
      next if target_locale == @base_locale

      Rails.logger.debug "ProjectTranslation: Translating to locale: #{target_locale}"
      translate_to_locale(target_locale)
    end
  end

  def delete_duplicate_translations
    return unless @duplicate_locales.any?

    log_duplicate_deletion_start
    delete_duplicate_locale_records
    reload_model_after_translation_deletions
    @missing_locales.concat(@duplicate_locales)
  end

  def log_duplicate_deletion_start
    # :nocov:
    Rails.logger.debug "\nProjectTranslation: Deleting #{@duplicate_locales.count} duplicate translations..."
    # :nocov:
  end

  def delete_duplicate_locale_records
    @duplicate_locales.each do |locale|
      delete_translation_for_locale(locale)
    end
  end

  def delete_translation_for_locale(locale)
    translation = context.model.translations.find_by(locale: locale.to_s)
    return unless translation

    translation.destroy
    # :nocov:
    Rails.logger.debug "  Deleted duplicate translation for locale: #{locale}"
    # :nocov:
  end

  def reload_model_after_translation_deletions
    # Clear association cache after deletions
    context.model.reload
  end

  def translate_to_locale(target_locale)
    content = @base_content[:content]

    if content.length > 2000
      Rails.logger.debug "  ⚠️  Content is too long (#{content.length} chars), splitting into chunks..."
      translate_long_content(target_locale, content)
    else
      translate_short_content(target_locale, content)
    end
  end

  def translate_short_content(target_locale, content)
    request = { content: }
    answer_gpt = call_translation_api_with_retry(target_locale, request)
    save_translation(target_locale, answer_gpt)
  end

  def call_translation_api_with_retry(target_locale, request)
    retries = 3
    begin
      EasyAccessGpt::Translation::SingleLocale.new(request, LOCALES[target_locale]).call
    rescue JSON::ParserError => e
      retries = handle_retry(target_locale, retries, e)
      retry
    rescue StandardError => e
      retries = handle_retry(target_locale, retries, e)
      retry
    end
  end

  def handle_retry(target_locale, retries, error)
    raise error unless retries.positive?

    # :nocov:
    Rails.logger.debug "  ⚠️  Retrying translation for #{target_locale} (#{3 - retries}/3)..."
    # :nocov:
    sleep(2)
    retries - 1
  end

  def translate_long_content(target_locale, content)
    chunks = split_content_into_chunks(content)
    # :nocov:
    Rails.logger.debug "  Split content into #{chunks.count} chunks"
    # :nocov:

    translated_chunks = translate_chunks(target_locale, chunks)
    combined_content = translated_chunks.join('')
    save_translation(target_locale, { 'content' => combined_content })
  end

  def split_content_into_chunks(content)
    chunks = []
    current_chunk = ''
    max_chunk_size = 1500
    paragraphs = content.split(%r{(</p>|</div>)}i)

    paragraphs.each do |para|
      current_chunk = process_paragraph(para, current_chunk, max_chunk_size, chunks)
    end
    chunks << current_chunk if current_chunk.present?
    chunks
  end

  def process_paragraph(para, current_chunk, max_chunk_size, chunks)
    if (current_chunk + para).length > max_chunk_size && current_chunk.present?
      chunks << current_chunk
      para
    else
      current_chunk + para
    end
  end

  def translate_chunks(target_locale, chunks)
    translated_chunks = []
    index = 0
    while index < chunks.length
      chunk = chunks[index]
      Rails.logger.debug "  Translating chunk #{index + 1}/#{chunks.count} (#{chunk.length} chars)..."
      translated_chunks << translate_single_chunk(target_locale, chunk, index)
      index += 1
    end
    translated_chunks
  end

  def translate_single_chunk(target_locale, chunk, index)
    request = { content: chunk }
    answer_gpt = call_chunk_translation(target_locale, request, chunk, index)
    return answer_gpt['content'] if answer_gpt.is_a?(Hash) && answer_gpt['content'].present?

    # :nocov:
    Rails.logger.debug "  ⚠️  Chunk #{index + 1} returned empty, using original"
    # :nocov:
    chunk
  end

  def call_chunk_translation(target_locale, request, chunk, index)
    retries = 3
    begin
      EasyAccessGpt::Translation::SingleLocale.new(request, LOCALES[target_locale]).call
    rescue JSON::ParserError => e
      retries = handle_chunk_retry(target_locale, chunk, index, retries, e)
      retry
    rescue StandardError => e
      retries = handle_chunk_retry(target_locale, chunk, index, retries, e)
      retry
    end
  end

  def handle_chunk_retry(target_locale, _chunk, index, retries, error)
    if retries.positive?
      log_chunk_retry(index, retries)
      sleep(2)
      retries - 1
    else
      log_chunk_failure(target_locale, index, error)
      retries
    end
  end

  def log_chunk_retry(index, retries)
    # :nocov:
    Rails.logger.debug "  ⚠️  Retrying chunk #{index + 1} (#{3 - retries}/3)..."
    # :nocov:
  end

  def log_chunk_failure(target_locale, index, error)
    # :nocov:
    Rails.logger.debug "  ✗ Failed to translate chunk #{index + 1}, using original"
    error_msg = "ProjectTranslation: Failed to translate chunk #{index + 1} for locale #{target_locale}: " \
                "#{error.message}"
    Rails.logger.error error_msg
    # :nocov:
  end

  def save_translation(target_locale, answer_gpt)
    I18n.with_locale(target_locale) do
      return unless answer_gpt.is_a?(Hash) && answer_gpt['content'].present?

      save_content_translation(target_locale, answer_gpt)
    end
  rescue JSON::ParserError => e
    handle_json_error(target_locale, e)
  rescue StandardError => e
    handle_save_error(target_locale, e)
  end

  def save_content_translation(target_locale, answer_gpt)
    context.model.content = answer_gpt['content']
    ensure_title_present_for_locale(target_locale)

    if context.model.save
      # :nocov:
      Rails.logger.debug "  ✓ Successfully saved translation for locale #{target_locale}"
      # :nocov:
    else
      log_save_failure(target_locale)
      context.fail!(error: "Failed to save translation for locale #{target_locale}")
    end
  end

  def ensure_title_present_for_locale(_target_locale)
    return if context.model.title.present?

    base_title = @base_content && @base_content[:title]
    context.model.title = base_title if base_title.present?
  end

  def log_save_failure(target_locale)
    # :nocov:
    Rails.logger.debug "  ✗ Failed to save translation for locale #{target_locale}"
    Rails.logger.debug "    Errors: #{context.model.errors.full_messages.inspect}"
    error_msg = "ProjectTranslation: Failed to save translation for locale #{target_locale}: " \
                "#{context.model.errors.full_messages.inspect}"
    Rails.logger.error error_msg
    # :nocov:
  end

  def handle_json_error(target_locale, error)
    # :nocov:
    Rails.logger.debug "  ✗ JSON parsing error for #{target_locale}: #{error.message}"
    Rails.logger.debug '    This usually means the response from ChatGPT was truncated or malformed.'
    Rails.logger.error "ProjectTranslation: JSON parsing error for locale #{target_locale}: #{error.message}"
    Rails.logger.error "ProjectTranslation: Backtrace: #{error.backtrace.first(5).join("\n")}"
    # :nocov:
  end

  def handle_save_error(target_locale, error)
    # :nocov:
    Rails.logger.debug "  ✗ Error saving translation for #{target_locale}: #{error.class}: #{error.message}"
    Rails.logger.error "ProjectTranslation: Error saving translation for locale #{target_locale}: #{error.message}"
    Rails.logger.error "ProjectTranslation: Backtrace: #{error.backtrace.first(10).join("\n")}"
    # :nocov:
  end

  def restore_original_locale
    I18n.locale = context.current_locale if context.current_locale.present?
  end
end
# rubocop:enable Metrics/ClassLength
