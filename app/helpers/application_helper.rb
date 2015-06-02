module ApplicationHelper
  def other_public_langs
    (ApplicationController::PUBLIC_LANGS.map(&:first) - [I18n.locale.to_s]).sort
  end

  def other_mobile_langs
    (ApplicationController::PUBLIC_LANGS.map { |l| [l.first, l.first.upcase + ' - ' + l.last] if l.first != I18n.locale.to_s }).compact
  end

  def other_langs
    (I18n.available_locales.map - [I18n.locale.to_s]).sort
  end

  def tech_link(technology)
    link = technology.link
    (link && !link.blank?) ? link : 'javascript:;'
  end
end
