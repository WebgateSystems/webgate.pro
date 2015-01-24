class Screenshot < ActiveRecord::Base
  belongs_to :project

  mount_uploader :file, ScreenshotUploader

  default_scope { order("position ASC") }

  validates_associated :project
end
