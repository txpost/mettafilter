class Comment < ActiveRecord::Base
	belongs_to :entry, :counter_cache => true 
end
