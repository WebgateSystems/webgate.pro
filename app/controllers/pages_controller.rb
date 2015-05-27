class PagesController < ApplicationController

  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    if @page.nil?
      redirect_to not_found_url
    end
  end

end
