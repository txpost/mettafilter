# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :authorize, :except => :login
  before_filter :set_user_time_zone, :current_user, :admin, :sidebar
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging "password", "email"
  
  protected
  
  def authorize
    unless User.find_by_id(@current_user)
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
  
  private
  
  def sidebar
    @sidebar = Entry.find_all_by_created_by('sidebar', :limit => 20, :order => "created_at DESC")
  end
  
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  
  def admin
    @admin = User.find_by_name("trev")
  end
  
  def set_user_time_zone
    @user = User.find_by_id(session[:user_id])
    Time.zone = @user.time_zone unless @user.blank?
  end
  
end
