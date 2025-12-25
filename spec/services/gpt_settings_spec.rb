# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GptSettings do
  describe '.enabled?' do
    it 'reflects Settings.services.gpt.enabled' do
      prev = Settings.services.gpt.enabled
      Settings.services.gpt.enabled = false
      expect(described_class.enabled?).to eq(false)
      Settings.services.gpt.enabled = true
      expect(described_class.enabled?).to eq(true)
    ensure
      Settings.services.gpt.enabled = prev
    end
  end

  describe '.key' do
    it 'prefers services.gpt.key and falls back to gpt_key' do
      prev_nested = Settings.services.gpt.key
      prev_legacy = Settings.gpt_key

      Settings.services.gpt.key = 'nested'
      Settings.gpt_key = 'legacy'
      expect(described_class.key).to eq('nested')

      Settings.services.gpt.key = ''
      expect(described_class.key).to eq('legacy')
    ensure
      Settings.services.gpt.key = prev_nested
      Settings.gpt_key = prev_legacy
    end
  end
end
