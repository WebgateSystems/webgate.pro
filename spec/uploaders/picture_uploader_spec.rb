require 'carrierwave/test/matchers'

describe PictureUploader do
  include CarrierWave::Test::Matchers

  let!(:project) { create(:project) }
  let!(:uploader) { described_class.new(project, :image) }

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
      expect(uploader.store_dir).to include("/public/spec/uploads/project/#{project.id}/image")
    end

    it 'exposes original store_dir implementation' do
      expect(uploader.store_dir_original).to eq("uploads/pictures/project/#{project.id}/image")
    end
  end

  # context 'the thumb version' do
  #   it 'scale down a landscape image to be exactly 182 by 114 pixels' do
  #     expect(uploader.thumb).to have_dimensions(182, 114)
  #   end
  # end

  # context 'the air version' do
  #   it 'scale down a landscape image to be exactly 182 by 114 pixels' do
  #     expect(uploader.air).to have_dimensions(182, 114)
  #   end
  # end
end
