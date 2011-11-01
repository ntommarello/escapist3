class GroupsController < ApplicationController
  def show
  end

  def new
  end

  def index
  end

  def edit
    
    #put in security check
    
    @info = Group.find(params[:id])
    
  end
  
  
  def update
    
    #put in security check
    
    @info = Group.find(params[:id])
    
    @info.update_attributes(params[:group])
    
    if params[:group][:domain]
      @info.domain = 1
    else
      @info.domain = 0
    end
    
    
    @info.save!
    
    flash[:message] = "Settings Saved"
    
    redirect_to "/groups/#{params[:id]}/edit"
    
  end
  
  
end
