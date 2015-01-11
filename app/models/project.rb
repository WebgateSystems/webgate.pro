#require 'carrierwave/orm/activerecord'

class Project < ActiveRecord::Base

  before_save :remove_translation_link
  after_save  :add_translation_link

  has_many :technologies, as: :taggable, dependent: :destroy
  accepts_nested_attributes_for :technologies, reject_if: :all_blank, allow_destroy: true

  validates :title, :shortlink, :description, :keywords, :content, presence: true
  validates_uniqueness_of :shortlink

  translates :title, :shortlink, :description, :keywords, :content

  #mount_uploader :screenshot1, :screenshot2, :screenshot3 LogoUploader

  private
  
  def remove_translation_link
    LinkTranslation.where(link_type: 'project', link: self.shortlink, locale: I18n.locale.to_s).first.try(:destroy)
  end

  def add_translation_link
    LinkTranslation.create(link: self.shortlink, locale: I18n.locale.to_s, link_type: 'project')
  end

end
