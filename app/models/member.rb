require 'carrierwave/orm/activerecord'

class Member < ActiveRecord::Base

  has_and_belongs_to_many :technologies
  #accepts_nested_attributes_for :technologies, reject_if: :all_blank

  validates_presence_of :name, :description, :shortdesc, :motto
  translates  :name, :description, :shortdesc, :motto

  mount_uploader :avatar , AvatarUploader
end
