# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GptTranslationRepairService do
  describe '#call' do
    it 'disables SSL verification for the underlying Net::HTTP client' do
      http = instance_double(Net::HTTP)
      allow(Net::HTTP).to receive(:new).and_return(http)
      allow(http).to receive(:use_ssl=)
      allow(http).to receive(:verify_mode=)

      body_json = '{"choices":[{"message":{"content":"{\\"html\\":\\"<p>OK</p>\\"}"}}]}'
      response = instance_double(Net::HTTPSuccess, body: body_json, code: '200')
      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      allow(http).to receive(:request).and_return(response)

      allow(Settings).to receive(:gpt_key).and_return('test')

      described_class.new.call(
        base_html: '<p>Źródło</p>',
        base_locale: :pl,
        current_target_html: '<p>Target</p>',
        target_locale: :de
      )

      expect(http).to have_received(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
    end
  end
end
