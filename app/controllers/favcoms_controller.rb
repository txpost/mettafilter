class FavcomsController < ApplicationController
  layout 'entries'
  before_filter :authorize, :except => [:index, :show]
  
  # GET /favcoms
  # GET /favcoms.xml
  def index
    @favcoms = Favcom.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @favcoms }
    end
  end

  # GET /favcoms/1
  # GET /favcoms/1.xml
  def show
    @favcom = Favcom.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @favcom }
    end
  end

  # GET /favcoms/new
  # GET /favcoms/new.xml
  def new
    @favcom = Favcom.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @favcom }
    end
  end

  # GET /favcoms/1/edit
  def edit
    @favcom = Favcom.find(params[:id])
  end

  # POST /favcoms
  # POST /favcoms.xml
  def create
    @favcom = Favcom.new(params[:favcom])

    respond_to do |format|
      if @favcom.save
        flash[:notice] = 'Favorite was successfully added.'
        format.html { redirect_to(:controller => 'entries', :action => 'index') }
        format.xml  { render :xml => @favcom, :status => :created, :location => @favcom }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @favcom.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /favcoms/1
  # PUT /favcoms/1.xml
  def update
    @favcom = Favcom.find(params[:id])

    respond_to do |format|
      if @favcom.update_attributes(params[:favcom])
        flash[:notice] = 'Favcom was successfully updated.'
        format.html { redirect_to(@favcom) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @favcom.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /favcoms/1
  # DELETE /favcoms/1.xml
  def destroy
    @favcom = Favcom.find(params[:id])
    @favcom.destroy

    respond_to do |format|
      format.html { redirect_to(favcoms_url) }
      format.xml  { head :ok }
    end
  end
end
