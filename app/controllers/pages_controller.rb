class PagesController < ApplicationController

  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    unless params[:locale].nil?
      I18n.locale = params[:locale]
    end
    if @page.nil?
      render :not_found, status: 404
      return
    end
  end

  def not_found
    @page_title = 'Error 404 - Page not found'
    render status: 404
  end

end
