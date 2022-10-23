class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: Settings.user.email.max_length, message: 'Do dai email vuot qua gia tri cho phep' },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  attr_accessor :remember_token, :activation_token, :reset_token, :api_token
  before_save :init_data
  before_create :create_activation_digest
  has_many :microposts, inverse_of: :user, dependent: :destroy
  has_many :follower_relationships, class_name: Relationship.name,
                                    foreign_key: :follower_id, dependent: :destroy
  has_many :followed_relationships, class_name: Relationship.name,
                                    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :follower_relationships, source: :followed
  has_many :followers, through: :followed_relationships, source: :follower
  has_many :comments, inverse_of: :user, dependent: :destroy

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end
  end

  def follow other_user #Follows a user.
    following << other_user
  end

  def unfollow other_user #Unfollows a user.
    following.delete other_user
  end

  def following? other_user #Returns if the current user is following the other_user or not
    following.include? other_user
  end

  def init_data
    self.phone_number = '0367279755'
    self.age = 33
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def generate_api_token
    random_str = User.new_token
    payload = { user_id: id, api_token: random_str }
    token = JwtAuthentication.encode(payload)
    self.api_token = token
    update_attribute(:api_token_digest, User.digest(random_str))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    BCrypt::Password.new(digest).is_password? token
  end

  def admin?
    admin
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 1.minutes.ago
  end
end
