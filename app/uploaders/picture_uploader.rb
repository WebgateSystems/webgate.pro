class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [200, 100]
  end

  version :collage do
    process resize_to_fill: [940, 244]
  end

  version :avatar do
    process resize_to_fill: [135, 135]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
