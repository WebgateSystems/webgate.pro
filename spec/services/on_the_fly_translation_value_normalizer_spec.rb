# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OnTheFlyTranslationValueNormalizer do
  subject(:normalizer) { described_class.new }

  describe '#normalize' do
    it 'normalizes plain text by stripping tags and decoding entities' do
      value = "<p>Hello&nbsp;world &amp; everyone</p>\n"
      expect(normalizer.normalize(value, type: :plain)).to eq('Hello world & everyone')
    end

    it 'normalizes html by removing styling attributes but keeping semantic tags' do
      html = '<p class="x" style="color:red">Hi <strong id="y">there</strong></p>'
      out = normalizer.normalize(html, type: :html)
      expect(out).to include('<p>Hi <strong>there</strong></p>')
      expect(out).not_to include('style=')
      expect(out).not_to include('class=')
      expect(out).not_to include('id=')
    end
  end
end
