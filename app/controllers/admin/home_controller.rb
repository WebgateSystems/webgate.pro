module Admin
  class HomeController < ApplicationController
    layout 'admin'
    before_action :require_login

    def index; end
  end
end
