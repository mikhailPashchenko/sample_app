class User < ApplicationRecord

  before_create :set_activation_token
  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: 50}
  validates :email,
    presence: true, length: { in: 3..255 },
    format: { with: ApplicationHelper::VALID_EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 4 }, allow_nil: true

  default_scope { where(active: true) }

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def forget
    self.remember_token = nil
    update_attribute(:remember_digest, nil)
  end

  def authenticated_with_token?(token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(token)
  end

  def is_god?
    role == 'admin'
  end

  private
  def set_activation_token
    token = User.digest(User.new_token)
    self.activation_token = token
  end
end
