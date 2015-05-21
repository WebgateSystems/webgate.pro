class PagesController < ApplicationController

  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    if @page.nil?
      render :not_found, status: 404
      return
    end
  end

  def not_found
    @page_title = t(:error_404)
    render status: 404
  end

end
