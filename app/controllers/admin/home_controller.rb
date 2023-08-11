module Admin
  class HomeController < ApplicationController
    layout 'admin'
    before_action :require_login

    def index; end

    def add_translate(model, path)
      ::TranslationWorker.perform_async(model.class, model.id, cookies[:lang])
      redirect_to(path, notice: 'text is being translated')
    end
  end
end
