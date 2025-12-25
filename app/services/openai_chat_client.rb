# frozen_string_literal: true

require 'json'
require 'net/http'
require 'openssl'
require 'uri'

class OpenaiChatClient
  class Error < StandardError; end

  ENDPOINT = 'https://api.openai.com/v1/chat/completions'

  def initialize(api_key:)
    @api_key = api_key
  end

  def chat!(model:, prompt:, temperature: 0.2)
    raise Error, 'Missing GPT key' if @api_key.blank?

    uri = URI.parse(ENDPOINT)
    http = build_http(uri)
    req = build_request(uri, model:, prompt:, temperature:)

    res = http.request(req)
    parse_response!(res)
  rescue JSON::ParserError => e
    raise Error, "OpenAI JSON parse error: #{e.message}"
  end

  private

  def build_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # Some servers fail SSL verification due to missing CRL/CA chain (e.g. "unable to get certificate CRL").
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def build_request(uri, model:, prompt:, temperature:)
    req = Net::HTTP::Post.new(uri.request_uri)
    apply_headers(req)
    req.body = request_body(model:, prompt:, temperature:)
    req
  end

  def apply_headers(req)
    req['Authorization'] = "Bearer #{@api_key}"
    req['Content-Type'] = 'application/json'
  end

  def request_body(model:, prompt:, temperature:)
    JSON.dump(
      model:,
      temperature:,
      messages: [
        { role: 'system', content: 'Return JSON only.' },
        { role: 'user', content: prompt }
      ]
    )
  end

  def parse_response!(res)
    raise Error, "OpenAI HTTP #{res.code}: #{res.body.to_s[0..300]}" unless res.is_a?(Net::HTTPSuccess)

    body = JSON.parse(res.body)
    content = body.dig('choices', 0, 'message', 'content')
    raise Error, "OpenAI response missing content: #{res.body.to_s[0..300]}" if content.blank?

    content
  end
end
