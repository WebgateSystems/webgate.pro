# encoding: utf-8
class ScreenshotUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/projects/#{model.id}/#{mounted_as}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :make_thumb
    process :convert => 'jpg'
    def full_filename(for_file)
      "thumb.jpg"
    end
  end

  version :large do
    process :make_large
    process :convert => 'jpg'
    def full_filename(for_file)
      "large.jpg"
    end
  end

  version :air do
    process :make_air
    process :convert => 'jpg'
    def full_filename(for_file)
      "air.jpg"
    end
  end

  def make_air
    manipulate! do |source|
      upper_layer = MiniMagick::Image.new("app/assets/images/layer4.png")
      source.resize "182"
      source.crop("182x114+0+0")
      result = source.composite(upper_layer) do |c|
        c.compose "Over"
        c.geometry "+86+0"
      end
      #  if needed air background added "+51+13"
      result
    end
  end

  def make_thumb
    manipulate! do |source|
      source.resize "182"
      source.crop("182x114+0+0")
      source
    end
  end

  def make_large
    manipulate! do |source|
      # source.crop("x1720+0+0")
      source.resize "x1720"
      source
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "original.#{file.extension}" if original_filename
  end

end
