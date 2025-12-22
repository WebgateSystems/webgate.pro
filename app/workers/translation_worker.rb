class TranslationWorker
  include Sidekiq::Worker

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform(klass, id, current_locale)
    msg = "TranslationWorker: Starting translation for #{klass} ID: #{id}, " \
          "current_locale: #{current_locale}"
    # :nocov:
    Rails.logger.debug msg
    # :nocov:
    model = klass.constantize.find(id)
    # :nocov:
    Rails.logger.debug "TranslationWorker: Found model: #{model.class.name}##{model.id}"
    # :nocov:
    begin
      # Use ProjectTranslation for Project model, AddTranslation for others
      if klass == 'Project'
        # :nocov:
        Rails.logger.debug 'TranslationWorker: Using ProjectTranslation interactor'
        # :nocov:
        result = ProjectTranslation.call(model:, current_locale:)
        # :nocov:
        Rails.logger.debug "TranslationWorker: ProjectTranslation result: #{result.success? ? 'success' : 'failed'}"
        Rails.logger.debug "TranslationWorker: ProjectTranslation error: #{result.error}" if result.failure?
        # :nocov:
      else
        # :nocov:
        Rails.logger.debug 'TranslationWorker: Using AddTranslation interactor'
        # :nocov:
        AddTranslation.call(model:, current_locale:)
      end
    rescue StandardError => e
      # :nocov:
      Rails.logger.error "TranslationWorker: Translation failed - #{e.class}: #{e.message}"
      Rails.logger.error "TranslationWorker: Backtrace: #{e.backtrace.first(10).join("\n")}"
      # :nocov:
    end
    # :nocov:
    Rails.logger.debug "TranslationWorker: Translation completed for #{klass} ID: #{id}"
    # :nocov:
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
