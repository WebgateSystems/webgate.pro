class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :redirect_to_blacklist_path, except: :blacklist
  before_action :common_prepare

  LANGS = [
    %w[de Deutsch],
    %w[en English],
    %w[fr Français],
    %w[pl Polski],
    %w[ru Русский],
    %w[ua Українська]
  ].freeze

  PUBLIC_LANGS = [
    %w[de Deutsch],
    %w[en English],
    %w[fr Français],
    %w[pl Polski],
    %w[ru Русский],
    %w[ua Українська]
  ].freeze

  def common_prepare
    prepare_lang
    @menu = Category.rank(:position).includes(:translations)
    @logged_to_admin = true if current_user
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #  flash[:error] = exception.message
  #  redirect_to root_url
  # end

  def not_authenticated
    redirect_to login_url, alert: t('first_login_to_access')
  end

  def redirect_if_user_decline_message
    return if cookies[:lang_accepted] || I18n.locale != :ru

    redirect_to root_path
  end

  def redirect_to_blacklist_path
    redirect_to blacklist_path if user_baned?
  end

  def user_baned?
    Blacklist.find_by(ip: request.remote_ip) ? true : false
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
    return user_accept_use_russian_language if params[:user_accepted]

    lang = params[:locale] || params[:lang] || cookies[:lang] || geoip_lang
    return check_accept_with_text(lang) if lang.to_s == 'ru'

    cookies_store_locale(lang)
  end

  def geoip_lang
    Bundler.require 'geoip'
    g = GeoIP.new(Rails.root.join('db/GeoIP.dat').to_s)
    country_code = g.country(request.remote_ip).country_code2.downcase
    case country_code
    when 'de', 'at' then 'de'
    when 'pl' then 'pl'
    when 'ua' then 'ua'
    when 'ru', 'by' then 'ru'
    else
      'en'
    end
  end

  def user_accept_use_russian_language
    cookies[:lang_accepted] = true
    check_accept_with_text(params[:locale])
  end

  def check_accept_with_text(lang)
    @accept_ru = true unless cookies[:lang_accepted]
    cookies_store_locale(lang)
  end

  def cookies_store_locale(lang)
    cookies[:lang] = lang_by_tag(lang)
    I18n.locale = lang_by_tag(lang)
  end

  def lang_by_tag(lng)
    language = LANGS.detect { |lang| lang.first == lng.downcase }
    language ? language.first : LANGS.first.first
  end
end
