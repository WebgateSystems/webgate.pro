class Category < ActiveRecord::Base
  include RankedModel
  ranks :position

  has_one :page, dependent: :destroy

  validates :name, :altlink, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  translates :name, :altlink, :description
end
