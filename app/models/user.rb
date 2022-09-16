class User
  include ActiveModel::Model
  include ActiveModel::SecurePassword
  include RedisStore

  has_secure_password

  attr_accessor :username, :password_digest, :password_confirmation

  validates :username, presence: true, unique: true

  identifier_attribute :username
end
