# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextTranslationNormalizer do
  describe '.call' do
    it 'removes wrapping and dangling quotes and trims whitespace/newlines' do
      text = " \n\"Hello world\"\n\n"
      expect(described_class.call(text)).to eq('Hello world')
    end

    it 'removes trailing dangling quotes' do
      text = "Opis technologii\n\""
      expect(described_class.call(text)).to eq('Opis technologii')
    end
  end
end
