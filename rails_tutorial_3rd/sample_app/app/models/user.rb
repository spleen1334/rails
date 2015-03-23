class User < ActiveRecord::Base

  has_many :microposts, dependent: :destroy

  # PAGINATION SETTING
  self.per_page = 10

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save { self.email = email.downcase } # isto sto i: self.email.downcase

  # account activation
  before_create :create_activation_digest

  # VALIDATION
  # -------------------------------------------------------
  # konstanta regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name  , presence: true, length: { maximum: 50 }
  validates :email , presence: true, length: { maximum: 100 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false } # uniquness validator nije case sensitive po defualtu
  validates :password, length: { minimum: 6 }, allow_blank: true # blank je za update action


  has_secure_password # rails magic (password_digest polje u db je neophodno),
  # omogucava i .authenticate method


  # METHODE
  # -------------------------------------------------------

  # Kreira hash za password, ovo se koristi zbog fixtures (test)
  def User.digest(string)
    # cost za production env i dev enviroment
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine::cost
    # logger.info ">>>>>>>>>>> cost: #{cost}"

    BCrypt::Password.create(string, cost: cost)
  end

  # Generise random token za cookies
  def User.new_token
    SecureRandom.urlsafe_base64
  end


  # Slicno kao has_secure_password ali za nase cookies
  # Generise privremeno polje remember_token koje se uporedjuje sa
  # remember_digest iz db.
  # Nakon toga se updateuje polje remember_digest koje prolazi kroz jos jedan
  # encrypt User.digest
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Cookies logout
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Provera za cookies/mail activation
  # *_digest = polje u db
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest") # dinamicki, za cookie ili mail activation
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Aktivacija accounta
  def activate
    # podsetnik self je opciono u modelu, self.update_attibute...
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    # alternativa za ceo row umesto update_attribute)
    update_columns( activated: true, activated_at: Time.zone.now )
  end

  # Salje aktivacioni mail(kod)
  def send_activation_mail
    UserMailer.account_activation(self).deliver_now
  end

  # Password reset attributi
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest, User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Posalji password reset mail
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Vreme od slanja pasword reset token
  # password reset sent EARLIER THEN 2h ago
  def password_reset_expired?
    reset_sent_at < 2.hours.ago # reset_sent_at db polje datetime
  end

  # Proto-feed > home page prikaz micropostova
  def feed
    Micropost.where("user_id = ?", id) # id u ovom context isto sto i self.id
    # isto sto i: microposts (isto sto i self.microposts)
  end


  private

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
