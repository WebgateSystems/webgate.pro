class HomeController < ApplicationController
  
  layout 'main'
  layout 'portfolio', only: :portfolio

  def index
  end

  def portfolio
    @projects = Project.published.all
  end
  
end
