class Admin::HomeController < ApplicationController
  layout 'admin'
  before_action  :require_login

  def index
  end
end
