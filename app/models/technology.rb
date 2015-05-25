require 'carrierwave/orm/activerecord'

class Technology < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :technology_group_id

  belongs_to :technology_group
  has_many :projects, through: :technologies_projects
  has_many :technologies_projects
  has_many :members, through: :technologies_members
  has_many :technologies_members

  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates_associated :technology_group
  validates :link, format: { with: URI.regexp }

  translates :description, :link

  mount_uploader :logo, LogoUploader

  after_update :update_members_cache

  protected

  def update_members_cache
    Member.all.each do |m|
      m.touch if m.technologies.include?(self)
    end
  end

end
