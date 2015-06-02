class Page < ActiveRecord::Base
  before_save :remove_translation_link
  after_save :add_translation_link

  belongs_to :category
  validates_associated :category

  validates :title, :shortlink, :description, :keywords, :content, presence: true
  validates :shortlink, uniqueness: { case_sensitive: false }
  validate :check_shortlink_unique

  translates :title, :shortlink, :description, :keywords, :content, :tooltip

  private

  def check_shortlink_unique
    shortlinks = []
    Page.where.not(id: self.id).includes(:translations).each do |page|
      I18n.available_locales.each do |l|
        Globalize.with_locale(l) do
          shortlinks << page.shortlink.downcase if page.shortlink
        end
      end
    end
    if self.shortlink && shortlinks.include?(self.shortlink.downcase)
      errors.add(:shortlink, I18n.t(:error_not_unique))
      return
    end
  end

  def remove_translation_link
    LinkTranslation.where(link_type: 'page', link: shortlink, locale: I18n.locale.to_s).first.try(:destroy)
  end

  def add_translation_link
    LinkTranslation.create(link: shortlink, locale: I18n.locale.to_s, link_type: 'page')
  end
end
