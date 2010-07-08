class Entry < ActiveRecord::Base
	validates_presence_of :body, :title
	validates_uniqueness_of :title

	has_many :comments
end
