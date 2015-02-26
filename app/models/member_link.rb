require 'carrierwave/orm/activerecord'

class MemberLink < ActiveRecord::Base

  belongs_to :member

  validates_presence_of :name, :link
  validates_associated :member

  translates :name

  mount_uploader :logo, LogoUploader
end
