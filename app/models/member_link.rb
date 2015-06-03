require 'carrierwave/orm/activerecord'

class MemberLink < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :member_id

  belongs_to :member, touch: true

  validates :name, :link, presence: true
  validates :link, format: { with: URI.regexp }
  validates_associated :member

  translates :name

end
