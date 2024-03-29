class Page < ApplicationRecord
  scope :published, -> { where(publish: true) }

  belongs_to :category

  validates :title, :shortlink, :description, :keywords, :content, presence: true
  validates_associated :category
  validates :shortlink, uniqueness: { case_sensitive: false }
  validate :check_shortlink_unique

  translates :title, :shortlink, :description, :keywords, :content, :tooltip

  private

  def check_shortlink_unique
    shortlinks = []
    Page.where.not(id:).includes(:translations).find_each do |page|
      I18n.available_locales.each do |l|
        Globalize.with_locale(l) do
          shortlinks << page.shortlink.downcase if page.shortlink
        end
      end
    end
    errors.add(:shortlink, I18n.t(:error_not_unique)) if shortlink && shortlinks.include?(shortlink.downcase)
  end
end
