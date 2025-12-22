# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe '#livelink_f' do
    it 'returns host from livelink' do
      project = build(:project, livelink: 'https://example.com/some/path')
      expect(project.livelink_f).to eq('example.com')
    end
  end

  describe 'screenshots nested attributes reject_if' do
    it 'rejects empty nested screenshot attributes' do
      project = create(:project)

      expect do
        project.update!(
          screenshots_attributes: [{ file: nil, file_cache: nil, id: nil }]
        )
      end.not_to(change { project.reload.screenshots.count })
    end
  end
end
