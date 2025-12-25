require 'carrierwave/test/matchers'

describe LogoUploader do
  include CarrierWave::Test::Matchers

  let!(:technology) { create(:technology) }
  let!(:uploader) { described_class.new(technology, :image) }

  before do
    described_class.enable_processing = true
    uploader.store!(File.open('spec/fixtures/projects/html5.png'))
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
      expect(uploader.file.extension).to eq('png')
    end

    it 'has a white list of allowed extensions' do
      expect(uploader.extension_white_list).to eq(%w[gif png])
    end

    it 'builds store_dir' do
      expect(uploader.store_dir).to include("/public/spec/uploads/technology/#{technology.id}/image")
    end

    it 'exposes original store_dir implementation' do
      expect(uploader.store_dir_original).to eq("uploads/logos/#{technology.id}/image")
    end
  end

  # context 'the thumb version' do
  #   it 'scale down a landscape image to be exactly 64 by 64 pixels' do
  #     expect(uploader.thumb).to have_dimensions(64, 64)
  #   end
  # end
end
