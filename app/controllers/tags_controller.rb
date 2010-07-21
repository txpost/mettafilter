class TagsController < ApplicationController
  layout 'entries'
  
  before_filter :authorize, :except => [:index, :show]

  def index
    @tags = Entry.tag_counts(:order => 'name').sort_by { |tag| tag.name.downcase }
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @matches = Entry.find_tagged_with(params[:query], :order => "created_at DESC")
    
    respond_to do |format|
      format.html
    end
  end
  
end
