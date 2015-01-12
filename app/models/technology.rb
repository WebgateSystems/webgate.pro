#require 'carrierwave/orm/activerecord'

class Technology < ActiveRecord::Base

  belongs_to :technology_group
  belongs_to :taggable, polymorphic: true

  validates :title, :description, presence: true
  validates_associated :technology_group
  validates_associated :taggable

  translates :description

  #mount_uploader :logo, LogoUploader

end
