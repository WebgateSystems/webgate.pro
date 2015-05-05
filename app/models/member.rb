require 'carrierwave/orm/activerecord'

class Member < ActiveRecord::Base
  include RankedModel
  ranks :position

  after_validation :check_avatar

  has_and_belongs_to_many :technologies
  #accepts_nested_attributes_for :technologies, reject_if: :all_blank
  has_many :member_links, dependent: :destroy
  accepts_nested_attributes_for :member_links, allow_destroy: true

  validates_presence_of :name, :job_title, :description, :motto
  translates  :name, :job_title, :description, :education, :motto

  scope :published, -> { where(publish: true) }

  mount_uploader :avatar , AvatarUploader

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
