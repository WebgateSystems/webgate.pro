class Blacklist < ApplicationRecord
  validates :ip, presence: true
end
