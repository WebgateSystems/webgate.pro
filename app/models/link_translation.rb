class LinkTranslation < ActiveRecord::Base
  validates :link, :locale, :link_type, presence: true
  validates :link, uniqueness: { scope: :locale }
end
