class OnTheFlyTranslator
  def initialize(
    gpt_service: GptTranslationRepairService.new,
    normalizer: OnTheFlyTranslationValueNormalizer.new,
    required_fields: OnTheFlyRequiredFieldsEnsurer.new
  )
    @gpt = gpt_service
    @normalizer = normalizer
    @required_fields = required_fields
  end

  # Translate specific fields from a source locale to target locales, preserving/correcting HTML when needed.
  #
  # model: globalized AR model instance (Project/Member/Technology)
  # source_locale: symbol/string of the locale user edited
  # fields: array of symbols (translated columns)
  # targets: array of locale symbols
  # field_types: hash { field => :html | :plain }
  def translate_fields!(model:, source_locale:, fields:, targets:, field_types:)
    src = source_locale.to_sym
    dsts = normalize_targets(targets, src)
    return if dsts.empty?

    OnTheFlyTranslation.with_silenced { translate_to_targets(model, fields, field_types, src, dsts) }
  end

  private

  def normalize_targets(targets, source_locale)
    targets.map(&:to_sym).uniq - [source_locale]
  end

  def translate_to_targets(model, fields, field_types, source_locale, target_locales)
    target_locales.each do |target_locale|
      translate_fields_for_target(model, fields, field_types, source_locale, target_locale)
    end
  end

  def translate_fields_for_target(model, fields, field_types, source_locale, target_locale)
    fields.each do |field|
      type = field_types.fetch(field, :plain)
      translate_field!(model:, field:, type:, source_locale:, target_locale:)
    end
  end

  def translate_field!(model:, field:, type:, source_locale:, target_locale:)
    source_value, current_value = translated_pair(model, field, source_locale, target_locale)
    return if both_blank?(source_value, current_value)

    write_translated(
      model,
      field,
      target_locale,
      translated_value(source_value, current_value, type, source_locale, target_locale)
    )
  end

  def translated_pair(model, field, source_locale, target_locale)
    [read_translated(model, field, source_locale), read_translated(model, field, target_locale)]
  end

  def both_blank?(*values)
    values.all?(&:blank?)
  end

  def translated_value(source_value, current_target_value, type, source_locale, target_locale)
    base_html = @normalizer.normalize(source_value, type:)
    current_html = @normalizer.normalize(current_target_value, type:)
    repaired = gpt_repair(base_html, source_locale, current_html, target_locale)
    @normalizer.normalize(repaired, type:)
  end

  def gpt_repair(base_html, base_locale, current_target_html, target_locale)
    @gpt.call(base_html:, base_locale:, current_target_html:, target_locale:)
  end

  def read_translated(model, field, locale)
    model.translations.find_by(locale: locale.to_s)&.public_send(field).to_s
  end

  def write_translated(model, field, locale, value)
    t = model.translations.find_or_initialize_by(locale: locale.to_s)
    t[field] = value
    @required_fields.ensure!(model, t)
    t.save!
  end
end
