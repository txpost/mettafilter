class CommentsController < ApplicationController
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
	    format.html { redirect_to(entries_url) }
	    format.js
	  end
	end
end

