require 'carrierwave/orm/activerecord'

class Member < ActiveRecord::Base
  include RankedModel
  ranks :position

  has_and_belongs_to_many :technologies
  #accepts_nested_attributes_for :technologies, reject_if: :all_blank
  has_many :member_links, dependent: :destroy
  accepts_nested_attributes_for :member_links, allow_destroy: true

  validates_presence_of :name, :description, :shortdesc, :motto, :avatar
  translates  :name, :description, :shortdesc, :motto

  mount_uploader :avatar , PictureUploader

  private

  def technologies_by_group(tech_group)
    #if tech_group.technologies & self.technologies
    #self.technologies.each do |technology|
    #if технология мембера входит в tg
    #          - выводим
    #          - if tg.include?(technology)
  end

end
