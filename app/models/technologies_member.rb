class TechnologiesMember < ApplicationRecord
  include RankedModel
  ranks :position, with_same: :member_id

  belongs_to :technology
  belongs_to :member, touch: true

  validates_associated :technology
  validates_associated :member
  validates :technology_id, uniqueness: { scope: [:member_id] }
end
