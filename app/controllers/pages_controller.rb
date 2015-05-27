class PagesController < ApplicationController

  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    if @page.nil?
      redirect_to notfound_url
    end
  end

end
