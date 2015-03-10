require 'rails_helper'
require 'carrierwave/test/matchers'

describe ScreenshotUploader do

  include CarrierWave::Test::Matchers

  let!(:project) { create(:project) }

  before do
    ScreenshotUploader.enable_processing = true
    @uploader = ScreenshotUploader.new(project, :image)
    @uploader.store!(File.open(File.join(Rails.root, '/spec/fixtures/projects/tested.jpg')))
  end

  after do
    ScreenshotUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 182 by 114 pixels" do
      @uploader.thumb.should have_dimensions(182, 114)
    end
  end

  context 'the air version' do
    it "should scale down a landscape image to be exactly 182 by 114 pixels" do
      @uploader.air.should have_dimensions(182, 114)
    end
  end

  context 'the large version' do
    it "should scale a landscape image to no taller then 1720 pixels" do
      @uploader.large.should be_no_taller_than(1720)
    end
  end

end
