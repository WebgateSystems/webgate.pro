require 'carrierwave/orm/activerecord'
require 'uri'

class Project < ActiveRecord::Base
  include RankedModel
  ranks :position

  scope :published, -> { where(publish: true) }

  has_many :technologies, -> { order('technologies_projects.position') }, through: :technologies_projects
  has_many :technologies_projects
  has_many :screenshots, dependent: :destroy
  accepts_nested_attributes_for :screenshots, reject_if: proc{ |param| param[:file].blank? && param[:file_cache].blank? && param[:id].blank? }, allow_destroy: true

  validates :title, :content, :livelink, presence: true
  validates :livelink, format: { with: URI.regexp }
  validate  :check_collage

  translates :title, :content

  mount_uploader :collage, CollageUploader

  def livelink_f
    URI(self.livelink).host
  end

  protected

  def check_collage
    if self.publish? and self.collage.to_s.empty?
      errors.add :publish, I18n.t('can_not_publish_without_collage')
    end
  end

end
