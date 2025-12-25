class GptTranslationRepairService
  class Error < StandardError; end

  MODEL = 'gpt-4o-mini'.freeze

  def initialize(api_key: GptSettings.key, client: nil)
    @client = client || OpenaiChatClient.new(api_key:)
  end

  # Returns repaired HTML (string) in target language, with styling removed.
  def call(base_html:, base_locale:, current_target_html:, target_locale:)
    HtmlTranslationNormalizer.call(
      repaired_html(base_html:, base_locale:, current_target_html:, target_locale:)
    )
  end

  private

  def repaired_html(base_html:, base_locale:, current_target_html:, target_locale:)
    base, target = normalized_locales(base_locale, target_locale)
    html = try_repair(base_html, base, current_target_html, target)
    return html if html

    force_repair(base_html, base, current_target_html, target)
  end

  def normalized_locales(base_locale, target_locale)
    [
      normalize_locale(target_locale: base_locale, label: 'base'),
      normalize_locale(target_locale:, label: 'target')
    ]
  end

  def try_repair(base_html, base_locale, current_target_html, target_locale)
    parsed = request_json(base_html, base_locale, current_target_html, target_locale, false)
    html_for_target(parsed, target_locale)
  end

  def force_repair(base_html, base_locale, current_target_html, target_locale)
    parsed = request_json(base_html, base_locale, current_target_html, target_locale, true)
    parsed.fetch('html')
  end

  def normalize_locale(target_locale:, label:)
    value = target_locale.to_s.downcase
    raise Error, "Invalid #{label} locale: #{value}" if value.blank?

    value
  end

  def request_json(base_html, base_locale, current_target_html, target_locale, strict_language)
    raw = @client.chat!(model: MODEL, prompt: prompt_for(
      base_html, base_locale, current_target_html, target_locale, strict_language
    ))
    parse_json(raw)
  rescue OpenaiChatClient::Error => e
    raise Error, e.message
  end

  def prompt_for(base_html, base_locale, current_target_html, target_locale, strict_language)
    GptTranslationPromptBuilder.new(
      base_html:,
      base_locale:,
      current_target_html:,
      target_locale:,
      strict_language:
    ).build
  end

  def html_for_target(parsed, target_locale)
    return if parsed['html'].blank?
    return unless parsed['lang'].to_s.downcase == target_locale

    parsed['html']
  end

  def parse_json(text)
    JSON.parse(text)
  rescue JSON::ParserError
    # Try to extract JSON substring if model wrapped it
    extracted = text.to_s[/\{[\s\S]*\}/]
    raise Error, "Response is not valid JSON: #{text.to_s[0..300]}" if extracted.blank?

    JSON.parse(extracted)
  end
end
