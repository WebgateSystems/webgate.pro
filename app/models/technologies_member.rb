class TechnologiesMember < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :member_id

  belongs_to :technology
  belongs_to :member

  validates_associated :technology
  validates_associated :member
end
