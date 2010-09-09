class TagsController < ApplicationController
  layout 'entries'

  def index
    @tags = Entry.tag_counts(:order => 'name').sort_by { |tag| tag.name.downcase }
    @sidebar = Entry.find(:all,
                            :conditions => ["created_by = 'sidebar'"],
                            :limit => 20,
                            :order => "created_at DESC")
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @matches = Entry.find_tagged_with(params[:query], :order => "created_at DESC")
    @sidebar = Entry.find(:all,
                            :conditions => ["created_by = 'sidebar'"],
                            :limit => 20,
                            :order => "created_at DESC")
    @favored_by = Favorite.find(:all, :conditions => ["user_id = ?", 
                                               session[:user_id]] )
    respond_to do |format|
      format.html
    end
  end
  
end
