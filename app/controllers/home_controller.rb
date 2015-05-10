class HomeController < ApplicationController
  layout 'portfolio', except: :index

  def index
    @projects = Project.published.rank(:position).all
    unless params[:lang].nil?
      I18n.locale = params[:lang]
      redirect_to root_path
    else
      render layout: 'main'
    end
  end

  def portfolio
    @projects = Project.published.rank(:position).page(params[:page]).per(10)
  end

  def team
    @members = Member.published.rank(:position).all.page(params[:page]).per(9)
    @technology_groups = TechnologyGroup.order(:position)
  end

end
