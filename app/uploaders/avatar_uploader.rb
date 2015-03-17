class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [135, 135]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :thumb do
    process :make_thumb
    process :convert => 'jpg'
    def full_filename(for_file)
      "thumb.jpg"
    end
  end

  #def make_thumb
    manipulate! do |source|
      source.resize "135!x135!"
      source
    end
  end

  def filename
    "original.#{file.extension}" if original_filename
  end

end
