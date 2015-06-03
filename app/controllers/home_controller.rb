class HomeController < ApplicationController
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

  def sitemap
    respond_to do |format|
      format.xml { render file: 'public/sitemaps/sitemap.xml' }
      format.html { redirect_to root_url }
    end
  end

  def robots
    # @pages = Page.where(published: false)
    respond_to :text
  end
end
