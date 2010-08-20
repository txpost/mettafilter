class UserSessionsController < ApplicationController
  layout "entries"
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    elsif @user_session.attempted_record &&
    !@user_session.invalid_password? &&
    !@user_session.attempted_record.active?
      flash[:notice] = render_to_string(:partial => 'user_sessions/not_active.erb',
                                        :locals => { :user => @user_session.attempted_record })
      redirect_to :action => :new
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end
