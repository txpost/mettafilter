class UsersController < ApplicationController
  layout 'entries'
  before_filter :authorize, :except => [:new, 
                                        :create, 
                                        :show, 
                                        :posts, 
                                        :comments, 
                                        :favorites, 
                                        :favcoms, 
                                        :resend_activation]
  before_filter :user
  uses_tiny_mce :options => { :theme => 'advanced', 
                              :theme_advanced_buttons1 => 'bold,italic,link,unlink',
                              :theme_advanced_buttons2 => '',
                              :theme_advanced_buttons3 => '',
                              :relative_urls => false,
                              :width => '600px',
                              :height => '200px' }
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all, :order => :login)
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user_entries = Entry.find( :all, 
                                :conditions => ["created_by = ?", params[:user_name]],
                                :order => "created_at DESC")
    @user_comments = Comment.find ( :all,
                                    :conditions => ["created_by =?", params[:user_name]],
                                    :order => "created_at DESC",
                                    :include => :entry)
    @user_favorites = @user.favorites.find (:all, :order => "created_at DESC")
    @user_favcoms = @user.favcoms.find (:all, :order => "created_at DESC")
  end
  
  def posts
    @user_entries = Entry.paginate :page => params[:page],
                                   :per_page => 30,
                                   :order => "created_at DESC",
                                   :conditions => ["created_by = ?", params[:user_name]] 
  end
  
  def comments
    @user_comments = Comment.paginate :page => params[:page],
                                      :per_page => 30,
                                      :order => "created_at DESC",
                                      :include => :entry,
                                      :conditions => ["created_by = ?", params[:user_name]]
  end
  
  def favorites
    @user_favorites = @user.favorites.paginate :page => params[:page],
                                               :per_page => 30,
                                               :order => "created_at DESC"                                               
  end
  
  def favcoms
    @user_favcoms = @user.favcoms.paginate :page => params[:page],
                                               :per_page => 30,
                                               :order => "created_at DESC"
  end
  
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your email for your account activation instructions!"
      redirect_to root_url
    else
      render :action => :new
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile update successful."
      redirect_to root_url
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(entries_url) }
      format.xml  { head :ok }
    end
  end
  
  def resend_activation
    if params[:login]
      @user = User.find_by_login(params[:login])
      if @user && !@user.active?
        @user.deliver_activation_instructions!
        flash[:notice] = "Please check your email for your account activation instructions!"
        redirect_to root_path
      end
    end
  end
  
  protected
  
  def user
    @user = User.find(:first, :conditions => ["login = ?", params[:user_name]])
  end
  
end
