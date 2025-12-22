# frozen_string_literal: true

class HtmlTranslationNormalizer
  # Removes inline styling and “styling attributes” while keeping semantic HTML.
  #
  # - Strips: style, class, id
  # - Unwraps <span> nodes that become attribute-less wrappers
  #
  # This is intentionally conservative: it does not remove tags like <strong>, <em>, <a>, etc.
  def self.call(html)
    return '' if html.blank?

    s = html.to_s.dup

    # Remove styling-related attributes (double or single quotes)
    s.gsub!(/\s+(style|class|id)=(["']).*?\2/i, '')

    # If spans became plain wrappers after stripping attributes, unwrap them.
    # Also unwrap spans that were already attribute-less.
    s.gsub!(/<span\s*>/i, '')
    s.gsub!(%r{</span>}i, '')

    s
  end
end
