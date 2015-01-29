# encoding: utf-8
class PagesController < ApplicationController

  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
#    @news = NewsEntry.find(:all, :order => :publish_at, :limit => 3)
    if @page.nil?
      render :not_found, status: 404
      return
    end
  end

  def not_found
    @page_title = 'Error 404 - Page not found'
#    @news = NewsEntry.find(:all, :order => :publish_at, :limit => 3)
    render status: 404
  end

end
