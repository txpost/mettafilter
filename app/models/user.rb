require 'digest/sha1'
class User < ActiveRecord::Base
  acts_as_authentic

  has_many :entries
  has_many :questions
  has_many :favorites
  has_many :favcoms
  has_attached_file :photo, :styles => { :small => "300x300>"}
  
  composed_of :tz,
              :class_name => 'TimeZone',
              :mapping => %w(time_zone name)
              
  attr_accessible :time_zone, 
                  :photo,
                  :login,
                  :password,
                  :password_confirmation,
                  :full_name, 
                  :about, 
                  :email,
                  :openid_identifier,
                  :role
                  
  attr_accessor :password_confirmation
  
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  def activate!
    self.active = true
    save
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end
  
  def deliver_welcome!
    reset_perishable_token!
    Notifier.deliver_welcome(self)
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  ROLES = %w[admin user guest]
  
  def role_symbols
    [role.to_sym]
  end
  
end
