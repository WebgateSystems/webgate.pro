require 'rails_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do

  include CarrierWave::Test::Matchers

  let!(:project) { create(:project) }

  before do
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(project, :image)
    @uploader.store!(File.open(File.join(Rails.root, '/spec/fixtures/projects/tested.jpg')))
  end

  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the avatar version' do
    it "should scale a landscape image to be exactly 180 by 180 pixels" do
      expect(@uploader.avatar).to have_dimensions(180, 180)
    end
  end

end
