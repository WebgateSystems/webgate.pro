class HomeController < ApplicationController
  layout 'main', except: :portfolio

  def index
    @projects = Project.published.all
  end

  def portfolio
    @projects = Project.published.all
    render layout: 'portfolio'
  end

end
