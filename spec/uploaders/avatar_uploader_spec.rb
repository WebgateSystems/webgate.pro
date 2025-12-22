require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let!(:member) { create(:member) }
  let!(:uploader) { described_class.new(member, :image) }

  before do
    described_class.enable_processing = true
    uploader.store!(File.open('spec/fixtures/projects/tested.jpg'))
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

    it 'has a white list of allowed extensions' do
      expect(uploader.extension_white_list).to eq(%w[jpg jpeg gif png])
    end

    it 'builds store_dir' do
      expect(uploader.store_dir).to include("/public/spec/uploads/member/#{member.id}/image")
    end
  end

  # context 'the avatar version' do
  #   it 'scale a landscape image to be exactly 180 by 180 pixels' do
  #     expect(uploader.avatar).to have_dimensions(180, 180)
  #   end
  # end
end
