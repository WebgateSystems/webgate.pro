class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates_uniqueness_of :email, message: I18n.t(:unique_email_error)
  validates_presence_of :email, :password, message: I18n.t(:presence_of_attributes_error)
  validates_confirmation_of :password, message: I18n.t(:password_confirmation_error)
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}

end
