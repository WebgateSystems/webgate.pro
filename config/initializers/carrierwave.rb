#initializer for carrierwave tests

if Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  # make sure our uploader is auto-loaded
  ScreenshotUploader

  # use different dirs when testing
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/spec/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/spec/uploads/project/#{model.id}/#{mounted_as}"
      end
    end
  end
end