# encoding: utf-8
class Category < ActiveRecord::Base
  #attr_accessible :name, :altlink, :description, :position
  has_one :page
  validates_uniqueness_of :name
  validates_presence_of :name, :altlink
  translates :name, :altlink, :description
  before_save :remove_translation_link
  after_save :add_translation_link

  def self.select_all
    res=[[]]
    Category.all(order: :id).each {|c| res.push [c.name, c.id] }
    res
  end

  private
  def remove_translation_link
    LinkTranslation.where(link_type: "category", link: self.altlink, locale: I18n.locale.to_s).first.try(:destroy)
  end

  def add_translation_link
    LinkTranslation.create(link: self.altlink, locale: I18n.locale.to_s, link_type: "category")
  end
end
