# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_user_time_zone, :sidebar
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging "password", "email"
  helper_method :current_user, :admin, :authorize
  
  private
  
  def sidebar
    @sidebar = Entry.find_all_by_created_by('sidebar', :limit => 20, :order => "created_at DESC")
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def authorize
    unless User.find_by_id(current_user)
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
  
  def admin
    @admin = User.find_by_login("trev")
  end
  
  def set_user_time_zone
    @user = User.find_by_id(session[:user_id])
    Time.zone = @user.time_zone unless @user.blank?
  end
  
end
