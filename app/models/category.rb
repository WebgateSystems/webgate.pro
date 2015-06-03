# encoding: utf-8
class Category < ActiveRecord::Base
  include RankedModel
  ranks :position

  has_one :page

  validates :name, :altlink, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  translates :name, :altlink, :description

  before_save :remove_translation_link
  after_save :add_translation_link

  private

  def remove_translation_link
    LinkTranslation.where(link_type: 'category', link: altlink, locale: I18n.locale.to_s).first.try(:destroy)
  end

  def add_translation_link
    LinkTranslation.create(link: altlink, locale: I18n.locale.to_s, link_type: 'category')
  end
end
