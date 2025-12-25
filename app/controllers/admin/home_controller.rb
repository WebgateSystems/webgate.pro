module Admin
  class HomeController < ApplicationController
    layout 'admin'
    before_action :require_login
    around_action :enable_on_the_fly_translation

    def index; end

    def add_translate(model, path)
      if GptSettings.enabled?
        redirect_to(path, notice: 'translations are generated on the fly')
      else
        ::TranslationWorker.perform_async(model.class.name, model.id, cookies[:lang])
        redirect_to(path, notice: 'text is being translated')
      end
    end

    private

    def enable_on_the_fly_translation(&block)
      OnTheFlyTranslation.with_enabled(&block)
    end
  end
end
