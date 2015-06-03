require 'rails_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let!(:member) { create(:member) }
  let!(:uploader) { described_class.new(member, :image) }

  before do
    described_class.enable_processing = true
    uploader.store!(File.open(File.join(Rails.root, '/spec/fixtures/projects/tested.jpg')))
  end

  after do
    described_class.enable_processing = false
    uploader.remove!
  end

  context 'the avatar version' do
    it 'scale a landscape image to be exactly 180 by 180 pixels' do
      expect(uploader.avatar).to have_dimensions(180, 180)
    end
  end
end
