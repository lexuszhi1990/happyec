class User < ActiveRecord::Base

  has_many :comments 
  has_many :posts
  attr_accessor :password  
  before_save :encrypt_password  
  before_create { generate_token(:auth_token) }
  before_validation :strip_blanks


  validates_confirmation_of :password  

  validates_presence_of :name, :email 
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :name, :email, :case_sensitive => false
  after_create { update_stream }
 
  def update_stream
     @stream_event = StreamEvent.new
     @stream_event.itemId = self.id
     @stream_event.userId = self.id
     @stream_event.item_type = "USER"
     @stream_event.time = self.created_at
     @stream_event.save
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
  def self.add_auth_token(user)
    @no_token_user = user
    @no_token_user.generate_token(:auth_token)
    @no_token_user.save!
  end
  def encrypt_password  
    if password.present?  
      self.password_salt = BCrypt::Engine.generate_salt  
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
    end  
  end  

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    PeterMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  protected

  def strip_blanks
    self.name = self.name.strip
    self.email = self.email.strip
  end
end
