require 'carrierwave/orm/activerecord'

class MemberLink < ActiveRecord::Base

  belongs_to :member

  validates_presence_of :name, :link
  validates :link, format: { with: URI.regexp }
  validates_associated :member

  translates :name

end
