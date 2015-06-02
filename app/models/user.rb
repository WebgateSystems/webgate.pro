class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates_uniqueness_of :email
  validates_presence_of :email, :password
  validates_confirmation_of :password
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
