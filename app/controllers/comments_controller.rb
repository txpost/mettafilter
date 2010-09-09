class CommentsController < ApplicationController
  layout 'entries'
  filter_resource_access
  
  uses_tiny_mce :options => { :theme => 'advanced', 
                              :theme_advanced_buttons1 => 'bold,italic,link,unlink',
                              :theme_advanced_buttons2 => '',
                              :theme_advanced_buttons3 => '' }
  
  def index
    @entries = Entry.paginate :page => params[:page], 
                              :per_page => 30, 
                              :order => "created_at DESC",
                              :conditions => ["comments_count > 5"] 
    @entry_days = @entries.group_by { |e| e.created_at.strftime("%B %d")}
    @comments = Comment.find(:all, 
                              :include => :entry, 
                              :order => "created_at DESC",
                              :limit => 10
                              )
    @favored_by = Favorite.find(:all, :conditions => ["user_id = ?", 
                                               session[:user_id]] )
    @favcomed_by = Favcom.find(:all, :conditions => ["user_id = ?",
                                                session[:user_id]] )
    @sidebar = Entry.find(:all,
                            :conditions => ["created_by = 'sidebar'"],
                            :limit => 20,
                            :order => "created_at DESC")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
			format.json { render :json => @entries }
			format.atom
    end
  end
  
  def create
		@entry = Entry.find(params[:entry_id])
		@comment = @entry.comments.create!(params[:comment])
		respond_to do |format|
		  flash[:notice] = 'Comment was successfully created.'
			format.html { redirect_to @entry }
			format.js
		end
	end
	
	def destroy
	  @comment = Comment.find(params[:id])
	  @comment.destroy
	  
	  respond_to do |format|
	    format.html { redirect_to(:back) }
	    format.js
	  end
	end
	
	def show
	  @comments = Comment.find(:all)
	  
	  respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
			format.json { render :json => @entries }
			format.atom
    end
  end
  
end

