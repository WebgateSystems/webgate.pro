# frozen_string_literal: true

class TextTranslationNormalizer
  # Cleans common artifacts like:
  # - leading/trailing quotes (", ', “ ”, „)
  # - trailing stray quotes after newlines
  # - excessive whitespace/newlines
  #
  # It is conservative: it mainly trims and removes obvious wrapping/dangling quotes.
  def self.call(text)
    return '' if text.nil?

    str = text.to_s
    str = str.tr("\u00A0", ' ') # nbsp
    str = str.strip
    str = str.gsub(/\r\n?/, "\n")
    str = str.gsub(/\n{3,}/, "\n\n")

    str = remove_wrapping_quotes(str)
    str = remove_dangling_trailing_quotes(str)
    str.strip
  end

  QUOTE_PAIRS = [
    ['"', '"'],
    ["'", "'"],
    ['“', '”'],
    ['„', '”']
  ].freeze

  def self.remove_wrapping_quotes(str)
    QUOTE_PAIRS.each do |open_q, close_q|
      next unless str.start_with?(open_q) && str.end_with?(close_q) && str.length >= 2

      str = str[1..-2].strip
    end

    str
  end

  def self.remove_dangling_trailing_quotes(str)
    # Remove trailing quote chars if they appear as obvious artifacts at the very end
    str.sub(/\s*["'“”„]+\s*\z/, '')
  end

  private_class_method :remove_wrapping_quotes, :remove_dangling_trailing_quotes
end
