require 'rails_helper'
require 'carrierwave/test/matchers'

describe PictureUploader do

  include CarrierWave::Test::Matchers

  let!(:project) { create(:project) }

  before do
    PictureUploader.enable_processing = true
    @uploader = PictureUploader.new(project, :image)
    @uploader.store!(File.open(File.join(Rails.root, '/spec/fixtures/projects/tested.jpg')))
  end

  after do
    PictureUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 182 by 114 pixels" do
      expect(@uploader.thumb).to have_dimensions(182, 114)
    end
  end

  context 'the air version' do
    it "should scale down a landscape image to be exactly 182 by 114 pixels" do
      expect(@uploader.air).to have_dimensions(182, 114)
    end
  end

  context 'the avatar version' do
    it "should scale a landscape image to be exactly 135 by 135 pixels" do
      expect(@uploader.avatar).to have_dimensions(135, 135)
    end
  end

  context 'the collage version' do
    it "should scale a landscape image to be exactly 940 by 244 pixels" do
      expect(@uploader.collage).to have_dimensions(940, 244)
    end
  end

end