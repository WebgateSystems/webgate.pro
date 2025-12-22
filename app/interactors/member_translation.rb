# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class MemberTranslation < BaseInteractor
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

  # Fields to translate
  TRANSLATED_FIELDS = %i[name education description motto job_title].freeze

  def call
    set_base_content
    if context.force_locale
      force_translate_locale(context.force_locale)
    else
      find_missing_locales
      translate_missing_locales
    end
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
      @base_content = extract_base_content
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

  def extract_base_content
    content = {}
    TRANSLATED_FIELDS.each do |field|
      content[field] = context.model.send(field)
    end
    content
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
    translation.nil? || translation.name.blank? || translation.description.blank?
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
      TRANSLATED_FIELDS.all? do |field|
        base_value = context.model.send(field)
        translation_value = translation.send(field)
        base_value.present? && translation_value.present? && base_value.strip == translation_value.strip
      end
    end
  end

  def translation_exists?(locale)
    translation = context.model.translations.find_by(locale: locale.to_s)
    translation.present? && translation.name.present? && translation.description.present?
  end

  def force_translate_locale(target_locale)
    return unless validate_target_locale(target_locale)

    delete_existing_translation(target_locale)
    Rails.logger.debug "MemberTranslation: Force translating to locale: #{target_locale}"
    translate_to_locale(target_locale)
  end

  def validate_target_locale(target_locale)
    unless I18n.available_locales.include?(target_locale)
      context.fail!(error: "Invalid locale: #{target_locale}")
      return false
    end

    if target_locale == @base_locale
      msg = "MemberTranslation: Target locale (#{target_locale}) is the same as base locale (#{@base_locale}), skipping"
      Rails.logger.debug msg
      return false
    end

    true
  end

  def delete_existing_translation(target_locale)
    translation = context.model.translations.find_by(locale: target_locale.to_s)
    return unless translation

    Rails.logger.debug "MemberTranslation: Deleting existing translation for locale: #{target_locale}"
    translation.destroy
    # Clear association cache so Globalize doesn't keep using a destroyed translation object
    context.model.reload
  end

  def translate_missing_locales
    delete_duplicate_translations
    return if @missing_locales.empty?

    Rails.logger.debug "\nMemberTranslation: Translating #{@missing_locales.count} missing locales"
    @missing_locales.each do |target_locale|
      next if target_locale == @base_locale

      Rails.logger.debug "MemberTranslation: Translating to locale: #{target_locale}"
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
    Rails.logger.debug "\nMemberTranslation: Deleting #{@duplicate_locales.count} duplicate translations..."
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
    long_fields = find_long_fields

    if long_fields.any?
      # :nocov:
      Rails.logger.debug '  ⚠️  Some fields are too long, translating separately...'
      # :nocov:
      translate_long_fields_separately(target_locale, long_fields)
    else
      translate_all_fields_at_once(target_locale)
    end
  end

  def find_long_fields
    TRANSLATED_FIELDS.select do |field|
      value = @base_content[field]
      value.present? && value.length > 2000
    end
  end

  def translate_all_fields_at_once(target_locale)
    request = build_translation_request
    answer_gpt = call_translation_api_with_retry(target_locale, request)
    save_translation(target_locale, answer_gpt)
  end

  def build_translation_request
    request = {}
    TRANSLATED_FIELDS.each do |field|
      value = @base_content[field]
      request[field] = value if value.present?
    end
    request
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

  def translate_long_fields_separately(target_locale, long_fields)
    answer_gpt = {}
    short_fields = TRANSLATED_FIELDS - long_fields

    translate_short_fields(target_locale, short_fields, answer_gpt)
    translate_long_fields(target_locale, long_fields, answer_gpt)

    save_translation(target_locale, answer_gpt)
  end

  def translate_short_fields(target_locale, short_fields, answer_gpt)
    short_request = build_short_fields_request(short_fields)
    return unless short_request.any?

    short_answer = call_short_fields_translation(target_locale, short_request)
    answer_gpt.merge!(short_answer) if short_answer.is_a?(Hash)
  end

  def call_short_fields_translation(target_locale, short_request)
    retries = 3
    begin
      EasyAccessGpt::Translation::SingleLocale.new(short_request, LOCALES[target_locale]).call
    rescue JSON::ParserError => e
      retries = handle_short_fields_retry(retries, e)
      retry
    rescue StandardError => e
      retries = handle_short_fields_retry(retries, e)
      retry
    end
  end

  def build_short_fields_request(short_fields)
    request = {}
    short_fields.each do |field|
      value = @base_content[field]
      request[field] = value if value.present?
    end
    request
  end

  def handle_short_fields_retry(retries, _error)
    if retries.positive?
      # :nocov:
      Rails.logger.debug "  ⚠️  Retrying short fields translation (#{3 - retries}/3)..."
      # :nocov:
      sleep(2)
      retries - 1
    else
      # :nocov:
      Rails.logger.debug '  ⚠️  Failed to translate short fields, continuing with long fields only...'
      # :nocov:
      retries
    end
  end

  def translate_long_fields(target_locale, long_fields, answer_gpt)
    long_fields.each do |field|
      value = @base_content[field]
      next if value.blank?

      # :nocov:
      Rails.logger.debug "  Translating #{field} (#{value.length} chars)..."
      # :nocov:
      field_answer = translate_single_field(target_locale, field, value)
      answer_gpt[field.to_s] = field_answer if field_answer.present?
    end
  end

  def translate_single_field(target_locale, field, value)
    field_request = { field => value }
    field_answer = call_field_translation(target_locale, field, field_request)
    return field_answer[field.to_s] if field_answer.is_a?(Hash) && field_answer[field.to_s].present?

    nil
  end

  def call_field_translation(target_locale, field, field_request)
    retries = 3
    begin
      EasyAccessGpt::Translation::SingleLocale.new(field_request, LOCALES[target_locale]).call
    rescue JSON::ParserError => e
      retries = handle_field_retry(field, target_locale, retries, e)
      retry
    rescue StandardError => e
      retries = handle_field_retry(field, target_locale, retries, e)
      retry
    end
  end

  def handle_field_retry(field, target_locale, retries, error)
    if retries.positive?
      # :nocov:
      Rails.logger.debug "  ⚠️  Retrying #{field} translation (#{3 - retries}/3)..."
      # :nocov:
      sleep(2)
      retries - 1
    else
      # :nocov:
      Rails.logger.debug "  ✗ Failed to translate #{field} after 3 retries"
      Rails.logger.error "MemberTranslation: Failed to translate #{field} for locale #{target_locale}: #{error.message}"
      # :nocov:
      retries
    end
  end

  def save_translation(target_locale, answer_gpt)
    I18n.with_locale(target_locale) do
      answer_gpt = normalize_answer_hash(answer_gpt)
      return unless answer_gpt.is_a?(Hash) && answer_gpt.any?

      assign_translation_fields(answer_gpt)
      save_and_verify_translation(target_locale)
    end
  rescue JSON::ParserError => e
    handle_json_error(target_locale, e)
  rescue StandardError => e
    handle_save_error(target_locale, e)
  end

  def assign_translation_fields(answer_gpt)
    # :nocov:
    Rails.logger.debug "  Saving translation for locale #{I18n.locale}..."
    Rails.logger.debug "  Received fields: #{answer_gpt.keys.inspect}"
    # :nocov:

    TRANSLATED_FIELDS.each do |field|
      assign_field_value(field, answer_gpt)
    end

    ensure_required_fields_present
  end

  def assign_field_value(field, answer_gpt)
    field_str = field.to_s
    if answer_gpt[field_str].present?
      value = answer_gpt[field_str]
      # :nocov:
      Rails.logger.debug "  Setting #{field} = #{value[0..50]}..." if value.present?
      # :nocov:
      context.model.send("#{field}=", value)
    else
      # :nocov:
      Rails.logger.debug "  ⚠️  Field #{field} is missing in answer_gpt"
      # :nocov:
    end
  end

  def ensure_required_fields_present
    required_fields = %i[name job_title description motto]
    required_fields.each do |field|
      next if context.model.send(field).present?

      fallback = @base_content && @base_content[field]
      context.model.send("#{field}=", fallback) if fallback.present?
    end
  end

  def save_and_verify_translation(target_locale)
    if context.model.save
      # :nocov:
      Rails.logger.debug "  ✓ Successfully saved translation for locale #{target_locale}"
      # :nocov:
      context.model.reload
      verify_translation_saved(target_locale)
    else
      log_save_failure(target_locale)
      context.fail!(error: "Failed to save translation for locale #{target_locale}")
    end
  end

  def verify_translation_saved(target_locale)
    saved_translation = context.model.translations.find_by(locale: target_locale.to_s)
    if saved_translation
      # :nocov:
      Rails.logger.debug "  ✓ Verified: Translation record exists in database for locale #{target_locale}"
      # :nocov:
      log_saved_fields(saved_translation)
    else
      # :nocov:
      Rails.logger.debug "  ✗ WARNING: Translation record NOT found in database for locale #{target_locale}"
      # :nocov:
    end
  end

  def log_saved_fields(saved_translation)
    TRANSLATED_FIELDS.each do |field|
      saved_value = saved_translation.send(field)
      if saved_value.present?
        # :nocov:
        Rails.logger.debug "    - #{field}: #{saved_value[0..50]}..."
        # :nocov:
      else
        # :nocov:
        Rails.logger.debug "    - ⚠️  #{field}: EMPTY"
        # :nocov:
      end
    end
  end

  def log_save_failure(target_locale)
    # :nocov:
    Rails.logger.debug "  ✗ Failed to save translation for locale #{target_locale}"
    Rails.logger.debug "    Errors: #{context.model.errors.full_messages.inspect}"
    error_msg = "MemberTranslation: Failed to save translation for locale #{target_locale}: " \
                "#{context.model.errors.full_messages.inspect}"
    Rails.logger.error error_msg
    # :nocov:
  end

  def handle_json_error(target_locale, error)
    # :nocov:
    Rails.logger.debug "  ✗ JSON parsing error for #{target_locale}: #{error.message}"
    Rails.logger.debug '    This usually means the response from ChatGPT was truncated or malformed.'
    Rails.logger.error "MemberTranslation: JSON parsing error for locale #{target_locale}: #{error.message}"
    Rails.logger.error "MemberTranslation: Backtrace: #{error.backtrace.first(5).join("\n")}"
    # :nocov:
  end

  def handle_save_error(target_locale, error)
    # :nocov:
    Rails.logger.debug "  ✗ Error saving translation for #{target_locale}: #{error.class}: #{error.message}"
    Rails.logger.error "MemberTranslation: Error saving translation for locale #{target_locale}: #{error.message}"
    Rails.logger.error "MemberTranslation: Backtrace: #{error.backtrace.first(10).join("\n")}"
    # :nocov:
  end

  def restore_original_locale
    I18n.locale = context.current_locale if context.current_locale.present?
  end
end
# rubocop:enable Metrics/ClassLength
