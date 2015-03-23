# HASHING
require 'digest/md5'

class User < ActiveRecord::Base
  # Rails 4 koristi strong_params u CTRL
  attr_accessible :avatar_url, :bio, :email, :name, :password, :password_confirmation, :username

  # Neophodan je password_digest column,
  # password/password_confirmation su temp var (oni ne postoje u db)
  has_secure_password

  # SQL RELACIJA
  has_many :ribbits

  # SPAJANJE TABELA
  has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :followed_relationships, class_name: 'Relationship', foreign_key: 'follower_id'

  # followers > lista onih koji prate odredjenog koristika
  # followeds > lista svih ljudi koje prati taj koristnik
  has_many :followers, through: :follower_relationships
  has_many :followeds, through: :followed_relationships

  before_validation :prep_email
  before_save :create_avatar_url

  validates :email, presence: true, uniqueness: true,
    format: { with: /^[\w\.+-]+@([\w]+\.)+[a-zA-Z]+$/ }
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true


  # Helper method
  # Nisam siguran da li postoji neko posebno meso za iste
  # Mislim da je u Rails4 to concerns/
  # Jer su helpers/ vise za view
  def following? user
    self.followeds.include? user
  end

  def follow user
    Relationship.create follower_id: self.id, followed_id: user.id
  end

  private

    # Preparation za gravatar
    def prep_email
      self.email = self.email.strip.downcase if self.email
    end

    def create_avatar_url
      self.avatar_url = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}?s=50"
    end
end
