class PagesController < ApplicationController
  def showbyshortlink
    @page = Page.where(shortlink: params[:shortlink]).first
    
    # ApplicationController::PUBLIC_LANGS.map(&:first).each do |lang|
    #   @page = Page.published.with_translations(lang).where(shortlink: params[:shortlink]).first
    #   unless @page.nil?
    #     I18n.locale = lang
    #     break
    #   end
    # end
    redirect_to not_found_url if @page.nil?
  end
end
