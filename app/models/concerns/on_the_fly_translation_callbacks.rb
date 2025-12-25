# frozen_string_literal: true

module OnTheFlyTranslationCallbacks
  extend ActiveSupport::Concern

  included do
    after_create :otf_translate_on_create
    after_update :otf_translate_on_update
  end

  private

  def otf_translate_on_create
    return unless OnTheFlyTranslation.enabled?
    return if OnTheFlyTranslation.silenced?

    model = otf_parent_model
    # Only treat as "new record" when this is the first translation row for the model.
    return unless model.translations.count == 1

    source_locale = locale.to_s.downcase.to_sym
    targets = I18n.available_locales - [source_locale]

    fields, field_types = otf_fields_and_types_for(model)
    OnTheFlyTranslator.new.translate_fields!(
      model:,
      source_locale:,
      fields:,
      targets:,
      field_types:
    )
  end

  def otf_translate_on_update
    return unless OnTheFlyTranslation.enabled?
    return if OnTheFlyTranslation.silenced?

    source_locale = locale.to_s.downcase.to_sym
    return unless source_locale == :pl

    model = otf_parent_model
    fields, field_types = otf_fields_and_types_for(model)

    changed = (saved_changes.keys.map(&:to_sym) & fields)
    return if changed.empty?

    targets = I18n.available_locales - [source_locale]
    OnTheFlyTranslator.new.translate_fields!(
      model:,
      source_locale:,
      fields: changed,
      targets:,
      field_types:
    )
  end

  def otf_parent_model
    # Globalize translation models commonly expose `globalized_model`
    return globalized_model if respond_to?(:globalized_model)

    # Fallback: infer parent class and foreign key (e.g. Project::Translation has `project_id`)
    parent_class = self.class.name.deconstantize.constantize
    fk = "#{parent_class.name.underscore}_id"
    return parent_class.find(public_send(fk)) if respond_to?(fk)

    raise "Unable to infer parent model for #{self.class.name}"
  end

  def otf_fields_and_types_for(model)
    case model
    when Project
      # user explicitly requested only content for projects
      [[:content], { content: :html }]
    when Technology
      [[:description], { description: :html }]
    when Member
      fields = %i[name job_title motto description education]
      types = {
        name: :plain,
        job_title: :plain,
        motto: :plain,
        description: :html,
        education: :html
      }
      [fields, types]
    else
      [[], {}]
    end
  end
end
