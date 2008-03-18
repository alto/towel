# == Schema Information
# Schema version: 9
#
# Table name: users
#
#  id                        :integer(11)     not null, primary key
#  login                     :string(255)     
#  email                     :string(255)     
#  crypted_password          :string(40)      
#  salt                      :string(40)      
#  created_at                :datetime        
#  updated_at                :datetime        
#  remember_token            :string(255)     
#  remember_token_expires_at :datetime        
#  activation_code           :string(40)      
#  activated_at              :datetime        
#  role                      :string(255)     
#  url_slug                  :string(255)     
#  deleted_at                :datetime        
#  inviter_id                :integer(11)     
#

require 'digest/sha1'
class User < ActiveRecord::Base

  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_acceptance_of   :terms_of_service, :message => "müssen akzeptiert werden"

  before_save   :encrypt_password
  before_create :make_activation_code 
  after_create  :deliver_signup_notification
  after_save    :deliver_activation
  
  acts_as_slugable :source_column => :login
  acts_as_deletable
  
  attr_accessible :login, :email, :password, :password_confirmation,
                  :description, :terms_of_service

  belongs_to :inviter, :class_name => 'User', :foreign_key => 'inviter_id'
  
  has_many :projects

  # Activates the user in the database.
  def activate(after_password_recover=false)
    if after_password_recover
      @password_recovered = true
    else
      @activated = true
    end
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end
  
  def num_views
    Eyeball.impressions_for(self)
  end

  def reset_activation
    self.activated_at = nil
    self.make_activation_code
    self.save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? AND activated_at IS NOT NULL AND deleted_at IS NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def display_name
    return 'N/A' if deleted?
    login
  end

  def to_param
    url_slug
  end
  
  def admin?
    self.role == 'admin'
  end

  def editable_by?(user)
    return false if user.nil? || user == :false
    return true if self.id == user.id
    false
  end
  
  protected
    def deliver_signup_notification
      UserMailer.deliver_signup_notification(self)
    end

    def deliver_activation
      if @activated
        UserMailer.deliver_activation(self)
      elsif @password_recovered
        UserMailer.deliver_password_recovered(self)
      end
    end

    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
end
