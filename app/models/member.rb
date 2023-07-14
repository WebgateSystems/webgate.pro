require 'carrierwave/orm/activerecord'

class Member < ApplicationRecord
  include RankedModel
  ranks :position

  scope :published, -> { where(publish: true) }

  has_many :technologies_members, dependent: :destroy
  has_many :member_links, dependent: :destroy
  has_many :technologies, -> { order('technologies_members.position') }, through: :technologies_members

  accepts_nested_attributes_for :member_links, allow_destroy: true

  validates :name, :job_title, :description, :motto, presence: true
  validate :check_avatar

  translates :name, :job_title, :description, :education, :motto

  mount_uploader :avatar, AvatarUploader

  def technology_groups
    TechnologyGroup.includes(:technologies, :translations)
                   .where(id: technologies.includes(:translations).map(&:technology_group_id).uniq).rank(:position)
  end

  protected

  def check_avatar
    errors.add :publish, I18n.t(:can_not_publish_without_avatar) if publish? && avatar.to_s.empty?
  end
end
