class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :common_prepare

  PUBLIC_LANGS = [
    ['en', 'English'],
    ['pl', 'Polski'],
    ['ru', 'Русский']
  ]

  def common_prepare
    @google_analytics = false
    prepare_lang
    @google_analytics = false
    @menu = Category.rank(:position).all #order(:position, :created_at)
  end

  #rescue_from CanCan::AccessDenied do |exception|
  #  flash[:error] = exception.message
  #  redirect_to root_url
  #end

  def not_authenticated
    redirect_to login_url, :alert => "First login to access this page."
  end

  #def set_layout
  #  case request.user_agent # or use nginx and params[] flag
  #  when /iPhone/i, /Android/i && /mobile/i, /Windows Phone/i
  #    "mobile"
  #  else
  #    "main"
  #  end
  #end

  private
  def prepare_lang
    path_string = request.fullpath.split("/")
    curr_category = path_string[-2]
    curr_link = path_string.last
    curr_translation = LinkTranslation.find_by_link(CGI::unescape(curr_category)) unless curr_category.nil?
    if curr_translation
      curr_locale = curr_translation.locale
    else
      curr_translation = LinkTranslation.find_by_link(CGI::unescape(curr_link)) unless curr_link.nil?
      if curr_translation
        curr_locale = curr_translation.locale
      end
    end
    lang = params[:lang] || curr_locale || cookies[:lang] || geoip_lang

    cookies[:lang] = lang_by_tag(lang)
    I18n.locale = lang
  end

  def geoip_lang
    Bundler.require 'geoip'
    g = GeoIP.new(Rails.root + 'db/GeoIP.dat')
    country_code = g.country(request.remote_ip).country_code2.downcase
    case country_code
      when "pl"
        "pl"
      when "ru", "ua", "by"
        "ru"
      else
        "en"
    end
  end

  def lang_by_tag(lng)
    language = PUBLIC_LANGS.detect{|lang| lang.first == lng.downcase}
    language ? language.first : PUBLIC_LANGS.first.first
  end
end
