# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HtmlTranslationNormalizer do
  describe '.call' do
    it 'removes style/class/id attributes and unwraps empty spans' do
      html = '<p style="color:red" class="x"><span style="font-weight:bold">Hello</span> ' \
             '<span>World</span></p>'

      cleaned = described_class.call(html)

      expect(cleaned).to include('<p>')
      expect(cleaned).to include('Hello')
      expect(cleaned).to include('World')
      expect(cleaned).not_to include('style=')
      expect(cleaned).not_to include('class=')
      expect(cleaned).not_to include('id=')
    end
  end
end
