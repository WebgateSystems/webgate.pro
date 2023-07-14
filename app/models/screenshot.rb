require 'carrierwave/orm/activerecord'

class Screenshot < ApplicationRecord
  include RankedModel
  ranks :position, with_same: :project_id

  default_scope { order('position ASC') }

  belongs_to :project, touch: true

  validates :file, presence: true
  validates_associated :project

  mount_uploader :file, PictureUploader
end
