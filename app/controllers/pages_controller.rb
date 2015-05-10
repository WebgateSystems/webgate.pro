class PagesController < ApplicationController

  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    #Так как на них отдельного роута с форматом нет, то просто передать параметром :locale не получится
    #Как только будут созданы все странички, нужда отпадет. 
    unless params[:locale].nil?
      I18n.locale = params[:locale]
      redirect_to "/#{@page.shortlink}"
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
