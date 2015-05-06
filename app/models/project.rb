require 'carrierwave/orm/activerecord'
require 'uri'

class Project < ActiveRecord::Base
  include RankedModel
  ranks :position

  scope :published, -> { where(publish: true) }

  has_and_belongs_to_many :technologies
  has_many :screenshots, dependent: :destroy
  accepts_nested_attributes_for :screenshots, reject_if: proc{ |param| param[:file].blank? && param[:file_cache].blank? && param[:id].blank? }, allow_destroy: true

  validates :title, :content, :livelink, presence: true
  validates :livelink, format: { with: URI.regexp }

  translates :title, :content

  after_validation :check_collage

  mount_uploader :collage, CollageUploader

  def livelink_f
    URI(self.livelink).host
  end

  protected

  def check_collage
    unless self.collage?
      self.publish = false
    end
  end

end
