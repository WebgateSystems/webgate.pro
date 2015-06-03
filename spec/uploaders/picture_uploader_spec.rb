require 'rails_helper'
require 'carrierwave/test/matchers'

describe PictureUploader do
  include CarrierWave::Test::Matchers

  let!(:project) { create(:project) }
  let!(:uploader) { described_class.new(project, :image) }

  before do
    described_class.enable_processing = true
    uploader.store!(File.open(File.join(Rails.root, '/spec/fixtures/projects/tested.jpg')))
  end

  after do
    described_class.enable_processing = false
    uploader.remove!
  end

  context 'the thumb version' do
    it 'scale down a landscape image to be exactly 182 by 114 pixels' do
      expect(uploader.thumb).to have_dimensions(182, 114)
    end
  end

  context 'the air version' do
    it 'scale down a landscape image to be exactly 182 by 114 pixels' do
      expect(uploader.air).to have_dimensions(182, 114)
    end
  end
end
