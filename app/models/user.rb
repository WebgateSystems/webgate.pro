class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :email, :password, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, confirmation: true
end
