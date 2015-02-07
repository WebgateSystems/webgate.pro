# encoding: utf-8
class Page < ActiveRecord::Base
#  attr_accessible :title, :shortlink, :description, :keywords, :content, :tooltip, 
#                  :category_id, :subcategory_id, :position
  before_save :remove_translation_link
  after_save :add_translation_link


  belongs_to :category
  validates_uniqueness_of :shortlink
  validates_presence_of :title, :shortlink, :description, :keywords, :content, message: I18n.t(:presence_of_attributes_error)
  translates :title, :shortlink, :description, :keywords, :content, :tooltip

  private
  def remove_translation_link
    LinkTranslation.where(link_type: "page", link: self.shortlink, locale: I18n.locale.to_s).first.try(:destroy)
  end

  def add_translation_link
    LinkTranslation.create(link: self.shortlink, locale: I18n.locale.to_s, link_type: "page")
  end
end
