require 'rails_helper'
require 'carrierwave/test/matchers'

describe LogoUploader do
  include CarrierWave::Test::Matchers

  let!(:member) { create(:member) }

  before do
    LogoUploader.enable_processing = true
    @uploader = LogoUploader.new(member, :logo)
    @uploader.store!(File.open(File.join(Rails.root, '/app/assets/images/html5.png')))
  end

  after do
    LogoUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it 'should scale down a landscape image to be exactly 64 by 64 pixels' do
      expect(@uploader.thumb).to have_dimensions(64, 64)
    end
  end
end
