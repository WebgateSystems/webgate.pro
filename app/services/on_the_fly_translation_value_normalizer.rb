# frozen_string_literal: true

require 'cgi'

class OnTheFlyTranslationValueNormalizer
  def normalize(value, type:)
    case type
    when :html
      normalize_html(value)
    else
      normalize_plain_text(value)
    end
  end

  private

  def normalize_html(value)
    TextTranslationNormalizer.call(HtmlTranslationNormalizer.call(value.to_s))
  end

  def normalize_plain_text(value)
    stripped = ActionView::Base.full_sanitizer.sanitize(value.to_s)
    decoded = CGI.unescapeHTML(stripped.to_s)
    decoded = decoded.tr("\u00A0", ' ')
    decoded = decoded.gsub('&nbsp;', ' ')
    decoded.gsub(/\s+/, ' ').strip
  end
end
