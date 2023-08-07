class AddTranslation < BaseInteractor
  CURRENT_LANG = I18n.locale
  LANGUAGES_TRANSLATION = I18n.available_locales.excluding(CURRENT_LANG)

  def call
    prepare_request
    context.fail! if answer_gpt[:operation]

    add_translations
  end

  private

  def prepare_request
    @request = {}
    context.model.translated_attribute_names.each do |attribute|
      @request[attribute] = context.model[attribute]
    end
    @request
  end

  def answer_gpt
    @answer_gpt ||= EasyAccessGpt::Translation.new(@request).call
  end

  def add_translations
    LANGUAGES_TRANSLATION.each do |lang|
      I18n.locale = lang
      context.model.translated_attribute_names.each do |attribute|
        context.model[attribute] = answer_gpt[lang.to_s][attribute.to_s]
      end
      context.model.save
    end
  end
end
