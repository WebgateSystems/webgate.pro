class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :technologies, as: :taggable, dependent: :destroy

  validates_uniqueness_of :email, message: I18n.t(:unique_email_error)
  validates_presence_of :email, :password, message: I18n.t(:empty_field_error)
  validates_confirmation_of :password, message: I18n.t(:password_confirmation_error)

end
