class AdminController < ApplicationController
  layout 'users'
  
  def login    
    session[:user_id] = nil
    session[:user_name] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        session[:user_name] = user.name
        redirect_to :controller => 'entries', :action => "index"
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_name] = nil
    flash[:notice] = "Logged out"
    redirect_to :controller => 'entries', :action => 'index'
  end

  def index
    @entries = Entry.find(:all, :conditions => ["created_by = ?", session[:user_name]],
                                :order => "created_at DESC")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
		end
  end

end
