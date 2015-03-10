class Screenshot < ActiveRecord::Base

  belongs_to :project
  validates_associated :project

  default_scope { order("position ASC") }

  mount_uploader :file, ScreenshotUploader

end
