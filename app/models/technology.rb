require 'carrierwave/orm/activerecord'

class Technology < ActiveRecord::Base

  belongs_to :technology_group
  belongs_to :taggable, polymorphic: true

  validates_presence_of :title
  validates_uniqueness_of :title, case_sensitive: false
  validates_associated :taggable

  translates :description

  mount_uploader :logo, LogoUploader

  default_scope -> { order(title: :asc) }

end
