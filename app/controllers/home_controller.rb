class HomeController < ApplicationController
  layout 'portfolio', except: :index

  def index
    @projects = Project.published.rank(:position).all
    #unless params[:locale].nil?
    #  I18n.locale = params[:locale]
    #end
    #Rails.logger.info(request.path)
    #Rails.logger.info('----------------------------------------------------------------')
    render layout: 'main'
  end

  def portfolio
    @projects = Project.published.rank(:position).page(params[:page]).per(10)
  end

  def team
    @members = Member.published.rank(:position).includes(:translations, :member_links, :technologies).page(params[:page]).per(9)
    @technology_groups = TechnologyGroup.order(:position)
  end

  private

  #def locale_urls
  #  current_locale = I18n.locale
  #  path = request.path
  #
  #end

end
