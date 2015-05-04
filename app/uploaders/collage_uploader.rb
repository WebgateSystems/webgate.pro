class CollageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/pictures/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :collage do
    process resize_to_fill: [940, 244]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
