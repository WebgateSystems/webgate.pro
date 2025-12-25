# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  describe '#truncate_plain_text' do
    it 'strips HTML tags, decodes entities and truncates with ...' do
      html = '<p>Hello &amp; world&nbsp;</p>'
      out = helper.truncate_plain_text(html, length: 8)

      expect(out).to eq('Hello...')
    end
  end
end
