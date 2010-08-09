class Entry < ActiveRecord::Base
  acts_as_taggable

	validates_presence_of :body, :title
	validates_uniqueness_of :title

	has_many :comments, :dependent => :destroy
	has_many :favorites, :dependent => :destroy
	belongs_to :user
	
end
