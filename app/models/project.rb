require 'carrierwave/orm/activerecord'

class Project < ActiveRecord::Base

  before_save :check_for_publish
  before_save :remove_translation_link
  after_save  :add_translation_link

  has_and_belongs_to_many :technologies
  #accepts_nested_attributes_for :technologies, reject_if: :all_blank
  has_many :screenshots, dependent: :destroy
  accepts_nested_attributes_for :screenshots, reject_if: proc{ |param| param[:file].blank? && param[:file_cache].blank? && param[:id].blank? }, allow_destroy: true

  validates_presence_of :title, :shortlink, :description, :keywords, :content
  validates_uniqueness_of :shortlink

  translates :title, :shortlink, :description, :keywords, :content

  scope :published, -> { where(publish: true) }

  private
  
  def remove_translation_link
    LinkTranslation.where(link_type: 'project', link: self.shortlink, locale: I18n.locale.to_s).first.try(:destroy)
  end

  def add_translation_link
    LinkTranslation.create(link: self.shortlink, locale: I18n.locale.to_s, link_type: 'project')
  end

  def check_for_publish
    #self.publish = false if self.screenshots.count < 3
  end

end
