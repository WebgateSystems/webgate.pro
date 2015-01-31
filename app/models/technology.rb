require 'carrierwave/orm/activerecord'

class Technology < ActiveRecord::Base

  belongs_to :technology_group
  has_and_belongs_to_many :projects

  validates_presence_of :title
  validates_uniqueness_of :title, case_sensitive: false

  translates :description

  mount_uploader :logo, LogoUploader

  default_scope -> { order(title: :asc) }

end
