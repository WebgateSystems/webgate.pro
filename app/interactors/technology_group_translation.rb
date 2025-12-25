# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class TechnologyGroupTranslation < BaseInteractor
  LOCALES = {
    de: 'German',
    en: 'English',
    fr: 'French',
    pl: 'Polish',
    ru: 'Russian',
    ua: 'Ukrainian'
  }.freeze

  BASE_LOCALE = :pl
  TRANSLATED_FIELDS = %i[title description].freeze

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
    I18n.with_locale(locale) { @base_content = extract_base_content }
  end

  def assign_base_from_available_locale
    available_locale = I18n.available_locales.find { |l| translation_exists?(l) }
    return assign_base_from_locale(available_locale) if available_locale

    context.fail!(error: 'No base translation found')
  end

  def extract_base_content
    TRANSLATED_FIELDS.index_with do |field|
      context.model.public_send(field)
    end
  end

  def find_missing_locales
    @missing_locales = []
    @duplicate_locales = []

    I18n.available_locales.each do |locale|
      next if locale == @base_locale

      check_locale_status(locale)
    end
  end

  def check_locale_status(locale)
    translation = context.model.translations.find_by(locale: locale.to_s)

    if missing_translation?(translation)
      @missing_locales << locale
    elsif translation_identical_to_base?(translation)
      @duplicate_locales << locale
    end
  end

  def missing_translation?(translation)
    return true if translation.nil?

    required_fields.any? { |field| translation.public_send(field).blank? }
  end

  def translation_identical_to_base?(translation)
    I18n.with_locale(@base_locale) do
      comparable_fields.all? do |field|
        base_value = context.model.public_send(field)
        translated_value = translation.public_send(field)
        base_value.present? && translated_value.present? && base_value.strip == translated_value.strip
      end
    end
  end

  def translation_exists?(locale)
    translation = context.model.translations.find_by(locale: locale.to_s)
    translation.present? && required_fields.all? { |field| translation.public_send(field).present? }
  end

  def force_translate_locale(target_locale)
    target_locale = target_locale.to_sym
    return unless validate_target_locale(target_locale)

    delete_existing_translation(target_locale)
    translate_to_locale(target_locale)
  end

  def validate_target_locale(target_locale)
    unless I18n.available_locales.include?(target_locale)
      context.fail!(error: "Invalid locale: #{target_locale}")
      return false
    end

    return true unless target_locale == @base_locale

    false
  end

  def delete_existing_translation(target_locale)
    translation = context.model.translations.find_by(locale: target_locale.to_s)
    return unless translation

    translation.destroy
    context.model.reload
  end

  def translate_missing_locales
    delete_duplicate_translations
    return if @missing_locales.empty?

    @missing_locales.each do |target_locale|
      next if target_locale == @base_locale

      translate_to_locale(target_locale)
    end
  end

  def delete_duplicate_translations
    return if @duplicate_locales.empty?

    @duplicate_locales.each do |locale|
      translation = context.model.translations.find_by(locale: locale.to_s)
      translation&.destroy
    end
    context.model.reload
    @missing_locales.concat(@duplicate_locales)
  end

  def translate_to_locale(target_locale)
    request = build_translation_request
    answer_gpt = call_translation_api_with_retry(target_locale, request)
    save_translation(target_locale, normalize_answer_hash(answer_gpt))
  end

  def build_translation_request
    TRANSLATED_FIELDS.each_with_object({}) do |field, acc|
      value = @base_content[field]
      acc[field] = value if value.present?
    end
  end

  def call_translation_api_with_retry(target_locale, request)
    retries = 3
    begin
      EasyAccessGpt::Translation::SingleLocale.new(request, LOCALES[target_locale]).call
    rescue JSON::ParserError => e
      retries = handle_retry(retries, e)
      retry
    rescue StandardError => e
      retries = handle_retry(retries, e)
      retry
    end
  end

  def save_translation(target_locale, answer_gpt)
    I18n.with_locale(target_locale) do
      TRANSLATED_FIELDS.each do |field|
        value = answer_gpt[field.to_s]
        context.model.public_send("#{field}=", value) if value.present?
      end

      ensure_required_fields_present(target_locale)
      return if context.failure?

      context.fail!(error: "Failed to save translation for locale #{target_locale}") unless context.model.save
    end
  end

  def handle_retry(retries, error)
    raise error unless retries.positive?

    sleep(2)
    retries - 1
  end

  def ensure_required_fields_present(target_locale)
    missing = missing_required_fields
    return if missing.empty?

    context.fail!(
      error: "Missing fields in translated content for locale #{target_locale}: #{missing.join(', ')}"
    )
  end

  def missing_required_fields
    required_fields.select { |field| context.model.public_send(field).blank? }
  end

  def required_fields
    fields = [:title]
    fields << :description if @base_content && @base_content[:description].present?
    fields
  end

  def comparable_fields
    # Only compare fields that exist in the base content:
    # if base description is blank, don't mark duplicates based on it.
    required_fields
  end

  def restore_original_locale
    I18n.locale = context.current_locale if context.current_locale.present?
  end
end

# rubocop:enable Metrics/ClassLength
