class User < ActiveRecord::Base

  has_many :comments
  attr_accessor :password  
  before_save :encrypt_password  
  before_create { generate_token(:token) }

  validates_confirmation_of :password  

  validates_presence_of :name, :email, :password
  validates_uniqueness_of :name, :email  
  def self.create_from_hash(qqhash, openid)
    User.new.tap do |user|
      user.qqopenid = openid
      user.name = qqhash["nickname"]
      user.email = "not given"
      user.save!
    end
  end
  def self.authenticate(name, password)  
    user = find_by_name(name)  
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)  
      user  
    elsif user && (user.password_hash == nil)
    # when the user lost his password, I will go to mysql and remove password_hash
    # then the user can login without password, and update his profile to give
    # a new password
      user
    else  
      nil  
    end  
  end  
  def encrypt_password  
    if password.present?  
      self.password_salt = BCrypt::Engine.generate_salt  
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
    end  
  end  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
