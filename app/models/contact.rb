class Contact
  include ActiveModel::Model
  attr_accessor :name, :email, :content, :nickname

  validates :name, :email, :content, presence: true
  validates :email, format: { with: /\S+@@\S+\.\S+/ }
end
