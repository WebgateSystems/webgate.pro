class TranslationWorker
  include Sidekiq::Worker

  def perform(klass, id, current_locale)
    Rails.logger.debug 'start translation'
    model = klass.constantize.find(id)
    begin
      AddTranslation.call(model:, current_locale:)
    rescue StandardError => e
      Rails.logger.debug "translation failed #{e}"
    end
    Rails.logger.debug 'end translation'
  end
end
