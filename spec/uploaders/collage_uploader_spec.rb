require 'rails_helper'
require 'carrierwave/test/matchers'

describe CollageUploader do
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

  context 'when uploading an image' do
    it 'saves the uploaded file' do
      expect(uploader.file).to be_present
    end

    it 'has the correct format' do
      expect(uploader.file.extension).to eq('jpg')
    end
  end

  # context 'the collage version' do
  #   it 'scale a landscape image to be exactly 940 by 244 pixels' do
  #     expect(uploader.collage).to have_dimensions(940, 244)
  #   end
  # end
end
