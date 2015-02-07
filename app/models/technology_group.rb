class TechnologyGroup < ActiveRecord::Base

  has_many :technologies, dependent: :destroy

  validates_presence_of :title
  validates_uniqueness_of :title, case_sensitive: false

  translates :title, :description

end
