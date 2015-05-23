class TechnologyGroup < ActiveRecord::Base
  include RankedModel
  ranks :position

  has_many :technologies, dependent: :destroy

  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  translates :title, :description

end
