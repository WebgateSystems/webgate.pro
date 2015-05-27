module ApplicationHelper

  def other_public_langs
    (ApplicationController::PUBLIC_LANGS.map {|l| l.first.to_s} - [I18n.locale.to_s]).sort
  end

  def other_mobile_langs
    (ApplicationController::PUBLIC_LANGS.map {|l| [l.first, l.first.upcase.to_s + " - " + l.last.to_s] unless l.first == I18n.locale.to_s}.compact)
  end

  def other_langs
    (I18n.available_locales.map(&:to_s) - [I18n.locale.to_s]).sort
  end

  def tech_link(technology)
    link = technology.link
    (link and !link.blank?) ? link : 'javascript:;'
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
      link_to(lang.upcase, root_path(lang: lang))
    elsif params[:action] == 'showbyshortlink'
      page = Page.with_translations(locale).find_by(shortlink: params[:shortlink])
      link_to(lang.upcase, (page.nil? or page.shortlink == params[:shortlink]) ? not_found_url(lang) : page.shortlink)
    else
      link_to(lang.upcase, locale: lang)
    end
  end

  def change_mobile_lang_path(lang, label)
    if current_page?(root_path)
      link_to(root_path(lang: lang)) do
        raw("<span> #{label}</span>")
      end
    elsif params[:action] == 'showbyshortlink'
      page = Page.with_translations(locale).find_by(shortlink: params[:shortlink])
      link_to((page.nil? or page.shortlink == params[:shortlink]) ? not_found_url(lang) : page.shortlink) do
        raw("<span> #{label}</span>")
      end
    else
      link_to(locale: lang) do
        raw("<span> #{label}</span>")
      end
    end
  end

end
