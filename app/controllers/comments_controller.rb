class CommentsController < ApplicationController
  uses_tiny_mce :options => { :theme => 'advanced', 
                              :theme_advanced_buttons1 => 'bold,italic,link,unlink',
                              :theme_advanced_buttons2 => '',
                              :theme_advanced_buttons3 => '' }
  
  def create
		@entry = Entry.find(params[:entry_id])
		@comment = @entry.comments.create!(params[:comment])
		respond_to do |format|
			format.html { redirect_to @entry }
			format.js
		end
	end
	
	def destroy
	  @comment = Comment.find(params[:id])
	  @comment.destroy
	  
	  respond_to do |format|
	    format.html { redirect_to(:controller => 'comments', :action => 'show') }
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

