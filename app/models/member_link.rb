require 'carrierwave/orm/activerecord'

class MemberLink < ApplicationRecord
  include RankedModel
  ranks :position, with_same: :member_id

  belongs_to :member, touch: true

  validates :name, :link, presence: true
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates_associated :member

  translates :name
end
