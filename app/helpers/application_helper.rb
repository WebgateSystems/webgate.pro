module ApplicationHelper

  def other_public_langs
    (ApplicationController::PUBLIC_LANGS.map {|l| l.first.to_s} - [I18n.locale.to_s]).sort
  end

  def other_mobile_langs
    (ApplicationController::PUBLIC_LANGS.map {|l| l.first.upcase.to_s + " - " + l.last.to_s} - [I18n.locale.to_s]).sort
  end

  def other_langs
    (I18n.available_locales.map(&:to_s) - [I18n.locale.to_s]).sort
  end

end
