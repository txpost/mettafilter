# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_user_time_zone, :sidebar, :mailer_set_url_options
  helper :all # include all helpers, all the time
  helper_method :current_user, :current_user_session
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging "password", "email"
  before_filter { |c| Authorization.current_user = c.current_user }
  
  #protected
  
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
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page."
      redirect_to new_user_session_url
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged in to access this page."
      redirect_to root_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
    
  def set_user_time_zone
    @user = User.find_by_id(session[:user_id])
    Time.zone = @user.time_zone unless @user.blank?
  end
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  
end
