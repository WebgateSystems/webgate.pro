class Screenshot < ActiveRecord::Base
  belongs_to :project

  mount_uploader :file, ScreenshotUploader

  validates_associated :project
end
