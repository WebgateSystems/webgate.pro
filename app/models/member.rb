require 'carrierwave/orm/activerecord'

class Member < ActiveRecord::Base
  include RankedModel
  ranks :position

  scope :published, -> { where(publish: true) }

  has_and_belongs_to_many :technologies
  has_many :member_links, dependent: :destroy
  accepts_nested_attributes_for :member_links, allow_destroy: true

  validates  :name, :job_title, :description, :education, :motto, presence: true

  translates :name, :job_title, :description, :education, :motto

  after_validation :check_avatar

  mount_uploader :avatar, AvatarUploader

  def technology_groups
    TechnologyGroup.where(id: self.technologies.map(&:technology_group_id).uniq).rank(:position)
  end

  protected

  def check_avatar
    unless self.avatar?
      self.publish = false
    end
  end

end
