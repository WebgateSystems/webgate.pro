require 'carrierwave/orm/activerecord'

class Technology < ApplicationRecord
  include RankedModel
  ranks :position, with_same: :technology_group_id

  belongs_to :technology_group
  has_many :technologies_projects
  has_many :technologies_members

  has_many :projects, through: :technologies_projects
  has_many :members, through: :technologies_members

  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates_associated :technology_group
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp }

  translates :description, :link

  mount_uploader :logo, LogoUploader

  after_update :update_members_cache
  after_update :update_projects_cache

  protected

  def update_projects_cache
    projects.update_all(updated_at: Time.zone.now)
  end

  def update_members_cache
    members.update_all(updated_at: Time.zone.now)
  end
end
