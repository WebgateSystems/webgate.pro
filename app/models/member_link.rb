require 'carrierwave/orm/activerecord'

class MemberLink < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :member_id

  belongs_to :member

  validates_presence_of :name, :link
  validates :link, format: { with: URI.regexp }
  validates_associated :member

  translates :name

end
