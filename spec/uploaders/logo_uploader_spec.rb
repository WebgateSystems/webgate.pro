require 'carrierwave/test/matchers'

describe LogoUploader do
  include CarrierWave::Test::Matchers

  let!(:technology) { create(:technology) }
  let!(:uploader) { described_class.new(technology, :image) }

  before do
    described_class.enable_processing = true
    uploader.store!(File.open(Rails.root.join('/app/assets/images/html5.png').to_s))
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
  end

  # context 'the thumb version' do
  #   it 'scale down a landscape image to be exactly 64 by 64 pixels' do
  #     expect(uploader.thumb).to have_dimensions(64, 64)
  #   end
  # end
end
