class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :common_prepare

  LANGS = [
    %w(en English),
    %w(pl Polski),
    %w(ru Русский),
    %w(fr Français)
  ]

  PUBLIC_LANGS = [
    %w(en English),
    %w(pl Polski),
    %w(ru Русский)
  ]

  def common_prepare
    prepare_lang
    @menu = Category.rank(:position).includes(:translations, :page, page: :translations)
    @logged_to_admin = true if current_user
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #  flash[:error] = exception.message
  #  redirect_to root_url
  # end

  def not_authenticated
    redirect_to login_url, alert: t('first_login_to_access')
  end

  # def set_layout
  #  case request.user_agent # or use nginx and params[] flag
  #  when /iPhone/i, /Android/i && /mobile/i, /Windows Phone/i
  #    "mobile"
  #  else
  #    "main"
  #  end
  # end

  private

  def prepare_lang
    lang = params[:locale] || params[:lang] || cookies[:lang] || geoip_lang
    cookies[:lang] = lang_by_tag(lang)
    I18n.locale = lang
  end

  def geoip_lang
    Bundler.require 'geoip'
    g = GeoIP.new(Rails.root + 'db/GeoIP.dat')
    country_code = g.country(request.remote_ip).country_code2.downcase
    case country_code
    when 'pl'
      'pl'
    when 'ru', 'ua', 'by'
      'ru'
    else
      'en'
    end
  end

  def lang_by_tag(lng)
    language = LANGS.detect { |lang| lang.first == lng.downcase }
    language ? language.first : LANGS.first.first
  end
end
