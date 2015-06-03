require 'rails_helper'
require 'carrierwave/test/matchers'

describe LogoUploader do
  include CarrierWave::Test::Matchers

  let!(:technology) { create(:technology) }
  let!(:uploader) { described_class.new(technology, :image) }

  before do
    described_class.enable_processing = true
    uploader.store!(File.open(File.join(Rails.root, '/app/assets/images/html5.png')))
  end

  after do
    described_class.enable_processing = false
    uploader.remove!
  end

  context 'the thumb version' do
    it 'scale down a landscape image to be exactly 64 by 64 pixels' do
      expect(uploader.thumb).to have_dimensions(64, 64)
    end
  end
end
