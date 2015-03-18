class LogoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/logos/#{model.id}/#{mounted_as}"
  end

  version :thumb do
    process resize_to_fill: [64, 64]
  end

  def extension_white_list
    %w(gif png)
  end

end
