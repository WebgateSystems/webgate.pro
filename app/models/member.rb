require 'carrierwave/orm/activerecord'

class Member < ActiveRecord::Base
  include RankedModel
  ranks :position

  scope :published, -> { where(publish: true) }

  has_many :technologies, -> { order('technologies_members.position') }, through: :technologies_members
  has_many :technologies_members
  has_many :member_links, dependent: :destroy
  accepts_nested_attributes_for :member_links, allow_destroy: true

  validates :name, :job_title, :description, :motto, presence: true
  validate :check_avatar

  translates :name, :job_title, :description, :education, :motto

  mount_uploader :avatar, AvatarUploader

  def technology_groups
    TechnologyGroup.where(id: technologies.map(&:technology_group_id).uniq).rank(:position)
  end

  protected

  def check_avatar
    errors.add :publish, I18n.t(:can_not_publish_without_avatar) if self.publish? && avatar.to_s.empty?
  end
end
