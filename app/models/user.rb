class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50}
  validates :email, presence: true, length: { in: 3..255 }
end
