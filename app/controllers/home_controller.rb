class HomeController < ApplicationController
  layout 'main', except: :portfolio

  def index
    @projects = Project.published.rank(:position).all
  end

  def portfolio
    @projects = Project.published.rank(:position).all
    render layout: 'portfolio'
  end

end
