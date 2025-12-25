class HomeController < ApplicationController
  before_action :redirect_if_user_decline_message, only: %i[portfolio team]
  layout 'portfolio', except: :index

  def index
    # Disable caching for development to see changes immediately
    expires_now if Rails.env.development?
    @projects = Project.includes(:translations, :screenshots).published.rank(:position)
    render layout: 'main'
  end

  def portfolio
    @projects = Project.published.rank(:position).includes(:translations, :screenshots,
                                                           { technologies_projects: :technology },
                                                           { technologies: :translations },
                                                           :technologies).page(params[:page]).per(10)
  end

  def team
    @members = Member.published.rank(:position).includes(:translations, :member_links,
                                                         { member_links: :translations },
                                                         { technologies_members: :technology },
                                                         :technologies).page(params[:page]).per(12)
  end

  def version
    return render(json: { version: AppIdService.version }, status: :ok) if request.format.json?

    render plain: AppIdService.version, status: :ok
  end

  def spinup_status
    render plain: 'OK', status: :ok
  end
end
