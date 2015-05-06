require 'carrierwave/orm/activerecord'
require 'uri'

class Project < ActiveRecord::Base
  include RankedModel
  ranks :position

  after_validation :check_collage

  has_and_belongs_to_many :technologies
  has_many :screenshots, dependent: :destroy
  accepts_nested_attributes_for :screenshots, reject_if: proc{ |param| param[:file].blank? && param[:file_cache].blank? && param[:id].blank? }, allow_destroy: true

  validates_presence_of :title, :content, :livelink
  validates :livelink, format: { with: URI.regexp }

  translates :title, :content

  scope :published, -> { where(publish: true) }

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
