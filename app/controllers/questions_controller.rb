class QuestionsController < ApplicationController
  layout 'entries'
  before_filter :authorize, :except => [:index, :show]
  
  def index
    @entries = Entry.paginate :page => params[:page], 
                              :per_page => 15, 
                              :order => "created_at DESC",
                              :conditions => ["created_by != 'sidebar' and category = 'question'"] 
    @entry_days = @entries.group_by { |e| e.created_at.strftime("%B %d")}
    @comments = Comment.find(:all, 
                              :include => :entry, 
                              :order => "created_at DESC",
                              :limit => 10)
    @favored_by = Favorite.find_all_by_user_id(@current_user)
    @favcomed_by = Favcom.find_all_by_user_id(@current_user)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
			format.json { render :json => @entries }
			format.atom
    end
  end

end
