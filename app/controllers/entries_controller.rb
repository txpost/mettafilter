class EntriesController < ApplicationController
  uses_tiny_mce :options => { :theme => 'advanced', 
                              :theme_advanced_buttons1 => 'bold,italic,link,unlink',
                              :theme_advanced_buttons2 => '',
                              :theme_advanced_buttons3 => '',
                              :relative_urls => false }
  before_filter :authorize, :except => [:index, :show]
  # before_filter :authenticate, :except => [:index, :show]
	# GET /entries
  # GET /entries.xml
  def index
# @entries = Entry.find(:all, :order => "created_at DESC")
    @entries = Entry.paginate :page => params[:page], 
                              :per_page => 15, 
                              :order => "created_at DESC",
                              :conditions => ["created_by != 'sidebar'"] 
    @entry_days = @entries.group_by { |e| e.created_at.strftime("%B %d")}
    @comments = Comment.find(:all, 
                              :include => :entry, 
                              :order => "created_at DESC",
                              :limit => 10)
    @favored_by = Favorite.find(:all, :conditions => ["user_id = ?", 
                                               session[:user_id]] )
    @sidebar = Entry.find(:all,
                            :conditions => ["created_by = 'sidebar'"],
                            :limit => 20,
                            :order => "created_at DESC")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
			format.json { render :json => @entries }
			format.atom
    end
  end
  
  # GET /entries/1
  # GET /entries/1.xml
  def show
    @entry = Entry.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
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

  # POST /entries
  # POST /entries.xml
  def create
    @entry = Entry.new(params[:entry])

    respond_to do |format|
      if @entry.save
        flash[:notice] = 'Entry was successfully created.'
        format.html { redirect_to(@entry) }
        format.xml  { render :xml => @entry, :status => :created, :location => @entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.xml
  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:notice] = 'Entry was successfully updated.'
        format.html { redirect_to(@entry) }
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

  protected
  
  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end

	private

	def authenticate
		authenticate_or_request_with_http_basic do |name, password|
			name == "admin" && password == "secret"
		end
	end
end
