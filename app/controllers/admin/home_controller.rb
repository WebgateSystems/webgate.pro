module Admin
  class HomeController < ApplicationController
    layout 'admin'
    before_action :require_login

    def index; end

    def add_translate(model, path)
      AddTranslation.call(model:)
      redirect_to(path)
    end
  end
end
