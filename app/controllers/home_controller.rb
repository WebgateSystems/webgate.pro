class HomeController < ApplicationController
  before_action :redirect_if_user_decline_message, only: %i[portfolio team]
  layout 'portfolio', except: :index

  def index
    @projects = Project.published.rank(:position)
    render layout: 'main'
  end

  def portfolio
    @projects = Project.published.rank(:position).includes(:translations, :screenshots).page(params[:page]).per(10)
  end

  def team
    @members = Member.published.rank(:position).includes(:translations, :member_links,
                                                         member_links: :translations).page(params[:page]).per(12)
  end
end
