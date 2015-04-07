class Contact
  include ActiveModel::Model
  attr_accessor :name, :email, :content

  validates :name, :email, :content, presence: true
end
