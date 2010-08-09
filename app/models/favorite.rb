class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry, :counter_cache => true

end
