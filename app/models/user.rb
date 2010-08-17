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
                  :email
  attr_accessor :password_confirmation
  
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
end
