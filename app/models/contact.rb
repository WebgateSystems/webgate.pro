class Contact
  include ActiveModel::Model
  attr_accessor :name, :email, :content, :nickname

  validates :name, :email, :content, presence: true
end
