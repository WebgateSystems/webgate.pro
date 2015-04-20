require 'carrierwave/orm/activerecord'

class Technology < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :technology_group_id

  belongs_to :technology_group
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :members

  validates_presence_of :title
  validates_uniqueness_of :title, case_sensitive: false
  validates_associated :technology_group
  validates :link, format: { with: URI.regexp }

  translates :description, :link

  mount_uploader :logo, LogoUploader

end
