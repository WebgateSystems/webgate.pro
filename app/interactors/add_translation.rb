class AddTranslation < BaseInteractor
  LOCALES = {
    en: 'English',
    pl: 'Polish',
    ru: 'Russian',
    ua: 'Ukraine',
    fr: 'France'
  }.freeze

  def call
    prepare_request
    add_translations
    I18n.locale = context.current_locale
  end

  private

  def prepare_request
    @prepare_request ||= create_hash_request
  end

  def add_translations
    I18n.available_locales.each do |lang|
      I18n.locale = lang
      answer_gpt = EasyAccessGpt::Translation::SingleLocale.new(@request, LOCALES[lang]).call
      translation_attribute(answer_gpt)
    end
  end

  def translation_attribute(answer_gpt)
    prepare_request.each do |attribute, _value|
      context.model[attribute] = answer_gpt[attribute.to_s]
    end
    context.model.save
  end

  def create_hash_request
    @request = {}
    context.model.translated_attribute_names.each do |attribute|
      next if context.model[attribute].nil? || context.model[attribute] == '/'

      @request[attribute] = context.model[attribute]
    end
    @request
  end
end
