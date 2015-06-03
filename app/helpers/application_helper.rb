module ApplicationHelper
  def other_public_langs
    (ApplicationController::PUBLIC_LANGS.map(&:first) - [I18n.locale.to_s]).sort
  end

  def other_mobile_langs
    (ApplicationController::PUBLIC_LANGS.map { |l| [l.first, l.first.upcase + ' - ' + l.last] if l.first != I18n.locale.to_s }).compact
  end

  def other_langs
    (I18n.available_locales.map(&:to_s) - [I18n.locale.to_s]).sort
  end

  def tech_link(technology)
    link = technology.link
    (link && !link.blank?) ? link : 'javascript:;'
  end

  def compare_path(menu_item)
    URI.escape menu_item.altlink
  end

  def main_menu_path(menu_item)
    URI.escape(menu_item.name.mb_chars.downcase.to_s)
  end

  def menu_item_active?(menu_item)
    request.path == compare_path(menu_item) || request.path == '/' + compare_path(menu_item) ||
      request.path == '/' + main_menu_path(menu_item)
  end

  def main_url(lang)
    case lang
    when 'pl'
      link_to(lang.upcase, main_pl_url)
    when 'ru'
      link_to(lang.upcase, main_ru_url)
    else
      link_to(lang.upcase, locale: lang)
    end
  end

  def mobile_main_url(lang, label)
    case lang
    when 'pl'
      link_to(main_pl_path) do
        raw("<span> #{label}</span>")
      end
    when 'ru'
      link_to(main_ru_path) do
        raw("<span> #{label}</span>")
      end
    else
      link_to(locale: lang) do
        raw("<span> #{label}</span>")
      end
    end
  end

  def not_found_url(lang)
    case lang
    when 'pl'
      not_found_pl_url
    when 'ru'
      not_found_ru_url
    else
      not_found_url
    end
  end

  def change_lang_path(lang)
    if current_page?(root_path)
      main_url(lang)
    elsif params[:action] == 'showbyshortlink'
      page = Page.with_translations(locale).find_by(shortlink: params[:shortlink])
      link_to(lang.upcase, (page.nil? || page.shortlink == params[:shortlink]) ? not_found_url(lang) : page.shortlink)
    else
      link_to(lang.upcase, locale: lang)
    end
  end

  def change_mobile_lang_path(lang, label)
    if current_page?(root_path)
      mobile_main_url(lang, label)
    elsif params[:action] == 'showbyshortlink'
      page = Page.with_translations(locale).find_by(shortlink: params[:shortlink])
      link_to((page.nil? || page.shortlink == params[:shortlink]) ? not_found_url(lang) : page.shortlink) do
        raw("<span> #{label}</span>")
      end
    else
      link_to(locale: lang) do
        raw("<span> #{label}</span>")
      end
    end
  end
end
