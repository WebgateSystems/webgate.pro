class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/pictures/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :thumb do
    process resize_to_fill: [182, 114]
  end

  version :collage do
    process resize_to_fill: [940, 244]
  end

  version :avatar do
    process resize_to_fill: [135, 135]
  end

  version :air do
    process resize_to_fill: [182, 114]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
