# MiniMagick configuration for ImageMagick compatibility
# Automatically detect and configure for ImageMagick 6 or 7
# - ImageMagick 7: uses 'magick' command (convert is deprecated)
# - ImageMagick 6: uses 'convert' command
require 'mini_magick'

# Check if 'magick' command is available (ImageMagick 7)
magick_available = system('magick -version > /dev/null 2>&1')
if magick_available
  MiniMagick.configure do |config|
    # MiniMagick 4.12 supports :imagemagick7 for ImageMagick 7
    config.cli = :imagemagick7
  end
else
  # ImageMagick 6 - use default :imagemagick
  MiniMagick.configure do |config|
    config.cli = :imagemagick
  end
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
