class Contact
  include ActiveModel::Model
  attr_accessor :name, :email, :content, :nickname

  validates :name, :email, :content, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
