require 'carrierwave/orm/activerecord'
require 'uri'

class Project < ApplicationRecord
  include RankedModel
  ranks :position

  scope :published, -> { where(publish: true) }

  has_many :technologies_projects, dependent: :destroy
  has_many :screenshots, dependent: :destroy
  has_many :technologies, -> { order('technologies_projects.position') }, through: :technologies_projects

  accepts_nested_attributes_for :screenshots,
                                reject_if: proc { |param|
                                             param[:file].blank? && param[:file_cache].blank? && param[:id].blank?
                                           },
                                allow_destroy: true

  validates :title, :content, :livelink, presence: true
  validates :livelink, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validate  :check_collage

  translates :title, :content

  mount_uploader :collage, CollageUploader

  def livelink_f
    URI(livelink).host
  end

  protected

  def check_collage
    errors.add :publish, I18n.t('can_not_publish_without_collage') if publish? && collage.to_s.empty?
  end
end
