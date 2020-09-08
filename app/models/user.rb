class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_password_token

  FORMAT_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.size.name}
  validates :email, presence: true, length: {maximum: Settings.size.email},
    format: {with: FORMAT_EMAIL}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.size.password}, allow_nil: true

  before_save{email.downcase!}
  before_create :create_activation_digest

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember_digest_token
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget_token
    update_attribute :remember_digest, nil
  end

  def authenticate? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def active_account
    update activated: true, activated_at: Time.zone.now
  end

  def send_email_activation_account
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_password_digest
    self.reset_password_token = User.new_token
    rsd = User.digest reset_password_token
    update reset_digest: rsd, reset_sent_at: Time.zone.now
  end

  def clear_reset_digest
    update_attribute :reset_digest, nil
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def not_time_out?
    reset_sent_at > Settings.time_out.hours.ago
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def filter_post
    Micropost.select_posts id
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
