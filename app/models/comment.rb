class Comment < ActiveRecord::Base
	belongs_to :entry, :counter_cache => true
	has_many :favcoms
end
