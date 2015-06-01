class TechnologiesProject < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :project_id

  belongs_to :technology
  belongs_to :project

  validates_associated :technology
  validates_associated :project

  validates :technology_id, uniqueness: { scope: [:project_id] }
end
