require 'rails_helper'
require 'carrierwave/test/matchers'

describe CollageUploader do
  include CarrierWave::Test::Matchers

  let!(:project) { create(:project) }

  before do
    CollageUploader.enable_processing = true
    @uploader = CollageUploader.new(project, :image)
    @uploader.store!(File.open(File.join(Rails.root, '/spec/fixtures/projects/tested.jpg')))
  end

  after do
    CollageUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the collage version' do
    it 'should scale a landscape image to be exactly 940 by 244 pixels' do
      expect(@uploader.collage).to have_dimensions(940, 244)
    end
  end
end
