class UsersController < ApplicationController
  layout 'entries'
  before_filter :authorize, :except => [:new, :create, :show, :posts, :comments, :favorites, :favcoms]
  before_filter :side_bar, :param_user, :admin
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
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(:first, :conditions => ["name = ?", params[:user_name]])
    @user_entries = Entry.find( :all, 
                                :conditions => ["created_by = ?", params[:user_name]],
                                :order => "created_at DESC")
    @user_comments = Comment.find ( :all,
                                    :conditions => ["created_by =?", params[:user_name]],
                                    :order => "created_at DESC",
                                    :include => :entry)
    @user_favorites = @user.favorites.find (:all, :order => "created_at DESC")
    @user_favcoms = @user.favcoms.find (:all, :order => "created_at DESC")
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        format.html { redirect_to(:controller => 'entries', :action => 'index') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { redirect_to(:action => 'show', :user_name => session[:user_name]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
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
  
  protected
  
  def side_bar
    @sidebar = Entry.find(:all,
                            :conditions => ["created_by = 'sidebar'"],
                            :limit => 20,
                            :order => "created_at DESC")
  end
  
  def param_user
    @user = User.find(:first, :conditions => ["name = ?", params[:user_name]])
  end
  
  def admin
    @admin = User.find_by_name("trev")
  end
  
  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
  
end
