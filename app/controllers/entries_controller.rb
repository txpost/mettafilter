class EntriesController < ApplicationController
  uses_tiny_mce :options => { :theme => 'advanced', 
                              :theme_advanced_buttons1 => 'bold,italic,link,unlink',
                              :theme_advanced_buttons2 => '',
                              :theme_advanced_buttons3 => '',
                              :relative_urls => false,
                              :width => '600px',
                              :height => '200px' }
  before_filter :authorize, :except => [:index, :show]
  # before_filter :authenticate, :except => [:index, :show]
	# GET /entries
  # GET /entries.xml
  
  def index
# @entries = Entry.find(:all, :order => "created_at DESC")
    @entries = Entry.paginate :page => params[:page], 
                              :per_page => 30,
                              :order => "created_at DESC",
                              :conditions => ["created_by != ?", 'sidebar'] 
    @entry_days = @entries.group_by { |e| e.created_at.strftime("%B %d")}
    @comments = Comment.find(:all, 
                              :include => :entry, 
                              :order => "created_at DESC")
    @favored_by = Favorite.find_all_by_user_id(current_user)
    @favcomed_by = Favcom.find_all_by_user_id(current_user)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
			format.json { render :json => @entries }
			format.atom
    end
  end
    
  def admin_user
    @user = User.find_by_login("trev")
  end
  # GET /entries/1
  # GET /entries/1.xml
  def show
    @entry = Entry.find(params[:id])
    @favored_by = Favorite.find_all_by_user_id(current_user)
    @favcomed_by = Favcom.find_all_by_user_id(current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  def preview
    render :layout => false
  end

  # GET /entries/new
  # GET /entries/new.xml
  def new
    @entry = Entry.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  def add_favorite
    @favorite = Favorite.new(:entry_id => params[:entry_id], :user_id => params[:user_id])
    if @favorite.save
      render :text => "added to favorites", :layout => false
    end
  end

  def add_favcom
    @favcom = Favcom.new(:comment_id => params[:comment_id], :user_id => params[:user_id])
    if @favcom.save
      render :text => "added to favorites", :layout => false
    end
  end

  # POST /entries
  # POST /entries.xml
  def create
    @entry = Entry.new(params[:entry])
    
    if params[:preview_button] || !@entry.save
      render :action => 'new'
    else 
      flash[:notice] = 'Entry was successfully created.'
      redirect_to(@entry)
    end
  end

  # PUT /entries/1
  # PUT /entries/1.xml
  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:notice] = 'Entry was successfully updated.'
        format.html { redirect_to(:action => 'show') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.xml
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to(entries_url) }
      format.xml  { head :ok }
    end
  end

end
