class PagesController < ApplicationController
  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    render :not_found, status: 404 if @page.nil?
  end

  def not_found
    @page_title = t(:error_404)
    render status: 404
  end
end
