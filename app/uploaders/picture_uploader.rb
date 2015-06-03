class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/pictures/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :thumb do
    process resize_to_fill: [182, 114]
  end

  version :air do
    process :resize_and_crop
  end

  def resize_and_crop
    manipulate! do |source|
      source.resize '182'
      source.crop('182x114+0+0')
      source
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
