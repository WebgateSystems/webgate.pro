# frozen_string_literal: true

require 'json'
require 'net/http'
require 'openssl'
require 'uri'

class GptTranslationRepairService
  class Error < StandardError; end

  ENDPOINT = 'https://api.openai.com/v1/chat/completions'
  MODEL = 'gpt-4o-mini'

  def initialize(api_key: Settings.gpt_key)
    @api_key = api_key
  end

  # Returns repaired HTML (string) in target language, with styling removed.
  def call(base_html:, base_locale:, current_target_html:, target_locale:)
    ensure_api_key!

    target_locale = normalize_locale!(target_locale, label: 'target')
    base_locale = normalize_locale!(base_locale, label: 'base')

    base_html = base_html.to_s
    current_target_html = current_target_html.to_s

    prompt = build_prompt(base_html:, base_locale:, current_target_html:, target_locale:)
    raw = chat(prompt)
    parsed = parse_json(raw)
    html = parsed.fetch('html')

    HtmlTranslationNormalizer.call(html)
  end

  private

  def ensure_api_key!
    raise Error, 'Missing Settings.gpt_key' if @api_key.blank?
  end

  def normalize_locale!(locale, label:)
    value = locale.to_s
    raise Error, "Invalid #{label} locale: #{value}" if value.blank?

    value
  end

  def build_prompt(base_html:, base_locale:, current_target_html:, target_locale:)
    <<~PROMPT
      You are a professional translator and HTML cleaner.

      Task:
      - Target language: #{target_locale.upcase}
      - You will receive:
        (A) Source HTML in #{base_locale.upcase} (source of truth)
        (B) Current #{target_locale.upcase} HTML (may be wrong language, may contain inline styles/classes)
      - Output MUST be a JSON object with exactly one key: "html".
      - Value of "html" MUST be valid HTML and MUST contain ZERO inline styles and ZERO styling attributes:
        remove all style="", class="", id="" attributes.
      - Preserve structure and tags, but remove redundant wrapper spans if needed.
      - If (B) is already in the correct target language, keep its meaning but normalize/clean the HTML.
      - If (B) is NOT in the correct target language, translate from (A) to #{target_locale.upcase} and output cleaned HTML.
      - Do not output markdown. Do not include explanations.

      Source HTML (A):
      #{base_html}

      Current target HTML (B):
      #{current_target_html}
    PROMPT
  end

  def chat(prompt)
    uri = URI.parse(ENDPOINT)
    http = build_http(uri)
    req = build_request(uri, prompt)
    res = http.request(req)
    parse_chat_response(res)
  rescue JSON::ParserError => e
    raise Error, "OpenAI JSON parse error: #{e.message}"
  end

  def build_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # Some servers fail SSL verification due to missing CRL/CA chain (e.g. "unable to get certificate CRL").
    # For this internal task we intentionally disable verification.
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def build_request(uri, prompt)
    req = Net::HTTP::Post.new(uri.request_uri)
    req['Authorization'] = "Bearer #{@api_key}"
    req['Content-Type'] = 'application/json'
    req.body = JSON.dump(build_payload(prompt))
    req
  end

  def build_payload(prompt)
    {
      model: MODEL,
      temperature: 0.2,
      messages: [
        { role: 'system', content: 'Return JSON only.' },
        { role: 'user', content: prompt }
      ]
    }
  end

  def parse_chat_response(res)
    raise Error, "OpenAI HTTP #{res.code}: #{res.body.to_s[0..300]}" unless res.is_a?(Net::HTTPSuccess)

    body = JSON.parse(res.body)
    content = body.dig('choices', 0, 'message', 'content')
    raise Error, "OpenAI response missing content: #{res.body.to_s[0..300]}" if content.blank?

    content
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
