class User < ApplicationRecord
  #include ApplicationHelper

  validates :name, presence: true, length: { maximum: 50}
  validates :email,
    presence: true, length: { in: 3..255 },
    format: { with: ApplicationHelper::VALID_EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }
end
