# frozen_string_literal: true

class GptTranslationPromptBuilder
  LOCALE_NAMES = {
    de: 'German',
    en: 'English',
    fr: 'French',
    pl: 'Polish',
    ru: 'Russian',
    ua: 'Ukrainian'
  }.freeze

  def initialize(base_html:, base_locale:, current_target_html:, target_locale:, strict_language:)
    @base_html = base_html
    @base_locale = base_locale
    @current_target_html = current_target_html
    @target_locale = target_locale
    @strict_language = strict_language
  end

  def build
    <<~PROMPT
            You are a professional translator and HTML cleaner.

            Task:
            - Target language: #{target_lang} (#{target_locale.upcase})
      #{strict_line}      - You will receive:
              (A) Source HTML in #{base_lang} (#{base_locale.upcase}) (source of truth)
              (B) Current #{target_lang} (#{target_locale.upcase}) HTML (may be wrong language, may contain inline styles/classes)
            - Output MUST be a JSON object with exactly two keys: "lang" and "html".
            - "lang" MUST be the 2-letter code for the language of "html" (e.g. "de", "pl", "en").
            - Value of "html" MUST be valid HTML and MUST contain ZERO inline styles and ZERO styling attributes:
              remove all style="", class="", id="" attributes.
            - Preserve structure and tags, but remove redundant wrapper spans if needed.
            - If (B) is already in the correct target language, keep its meaning but normalize/clean the HTML.
            - If (B) is NOT in the correct target language, translate from (A) to #{target_lang} and output cleaned HTML.
            - Do not output markdown. Do not include explanations.

            Source HTML (A):
            #{@base_html}

            Current target HTML (B):
            #{@current_target_html}
    PROMPT
  end

  private

  attr_reader :base_locale, :target_locale

  def base_lang
    LOCALE_NAMES[base_locale.to_sym] || base_locale.upcase
  end

  def target_lang
    LOCALE_NAMES[target_locale.to_sym] || target_locale.upcase
  end

  def strict_line
    return '' unless @strict_language

    "      - IMPORTANT: Output language MUST be #{target_lang}.\n"
  end
end
