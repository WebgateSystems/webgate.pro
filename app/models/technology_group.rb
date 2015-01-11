class TechnologyGroup < ActiveRecord::Base

  has_many :technologies, dependent: :destroy

  validates :title, :description, presence: true

  translates :title, :description

end
