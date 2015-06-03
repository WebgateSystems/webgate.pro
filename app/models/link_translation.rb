class LinkTranslation < ActiveRecord::Base

  validates :link, :locale, :link_type, presence: true
  validates_uniqueness_of :link, scope: :locale

end
