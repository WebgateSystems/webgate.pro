class TranslationWorker
  include Sidekiq::Worker

  def perform(klass, id)
    model = klass.constantize.find(id)
    AddTranslation.call(model:)
  end
end
