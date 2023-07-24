class PagesController < ApplicationController
  def showbyshortlink
    ApplicationController::PUBLIC_LANGS.map(&:first).each do |lang|
      @page = Page.published.with_translations(lang).where(shortlink: params[:shortlink]).first
      next if @page.nil?

      redirect_if_user_decline_message
      I18n.locale = lang
      break
    end
    redirect_to not_found_url if @page.nil?
  end
end
