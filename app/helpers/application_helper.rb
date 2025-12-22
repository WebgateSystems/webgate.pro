module ApplicationHelper
  def other_public_langs
    (ApplicationController::PUBLIC_LANGS.map(&:first) - [I18n.locale.to_s]).sort
  end

  def other_mobile_langs
    (ApplicationController::PUBLIC_LANGS.map do |l|
       [l.first, "#{l.first.upcase} - #{l.last}"] if l.first != I18n.locale.to_s
     end).compact
  end

  def other_langs
    (I18n.available_locales.map(&:to_s) - [I18n.locale.to_s]).sort
  end

  def tech_link(technology)
    link = technology.link
    (link.presence || 'javascript:;')
  end

  def compare_path(menu_item)
    URI.escape menu_item.altlink
  end

  def main_menu_path(menu_item)
    name = menu_item&.name
    slug_source = name.presence || menu_item&.altlink.presence || ''
    URI.escape(slug_source.to_s.mb_chars.downcase.to_s)
  end

  def menu_item_active?(menu_item)
    request.path == compare_path(menu_item) || request.path == "/#{compare_path(menu_item)}" ||
      request.path == "/#{main_menu_path(menu_item)}"
  end

  def url_main(lang)
    I18n.with_locale(lang) do
      link_to(lang.upcase, main_url)
    end
  end

  def mobile_main_url(lang, label)
    I18n.with_locale(lang) do
      link_to(main_path) do
        raw("<span> #{label}</span>")
      end
    end
  end

  def url_not_found(lang)
    I18n.with_locale(lang) do
      not_found_url
    end
  end

  def change_lang_path(lang)
    if current_page?(root_path)
      url_main(lang)
    elsif params[:action] == 'showbyshortlink'
      page = Page.with_translations(locale).find_by(shortlink: params[:shortlink])
      link_to(lang.upcase, page.nil? || page.shortlink == params[:shortlink] ? url_not_found(lang) : page.shortlink)
    else
      link_to(lang.upcase, locale: lang)
    end
  end

  def change_mobile_lang_path(lang, label)
    if current_page?(root_path)
      mobile_main_url(lang, label)
    elsif params[:action] == 'showbyshortlink'
      page = Page.with_translations(locale).find_by(shortlink: params[:shortlink])
      link_to(page.nil? || page.shortlink == params[:shortlink] ? url_not_found(lang) : page.shortlink) do
        raw("<span> #{label}</span>")
      end
    else
      link_to(locale: lang) do
        raw("<span> #{label}</span>")
      end
    end
  end
end
