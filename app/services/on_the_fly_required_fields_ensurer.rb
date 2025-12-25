# frozen_string_literal: true

class OnTheFlyRequiredFieldsEnsurer
  def ensure!(model, translation_row)
    return ensure_project_required_fields(model, translation_row) if model.is_a?(Project)
    return ensure_member_required_fields(model, translation_row) if model.is_a?(Member)

    ensure_technology_required_fields(model, translation_row) if model.is_a?(Technology)
  end

  private

  def ensure_project_required_fields(model, translation_row)
    return if translation_row[:title].present?

    translation_row[:title] = model.translations.where.not(title: [nil, '']).first&.title
  end

  def ensure_member_required_fields(model, translation_row)
    %i[name job_title description motto].each do |field|
      next if translation_row[field].present?

      translation_row[field] = model.translations.where.not(field => [nil, '']).first&.public_send(field)
    end
  end

  def ensure_technology_required_fields(model, translation_row)
    return if translation_row[:link].present?

    translation_row[:link] = model.translations.where.not(link: [nil, '']).first&.link
  end
end
