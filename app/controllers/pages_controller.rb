class PagesController < ApplicationController
  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    redirect_to not_found_url if @page.nil?
  end
end
