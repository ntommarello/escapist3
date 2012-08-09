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
  
  
  def check_group_username
    @check = Group.find(:all, :conditions=>"username='#{params[:username]}' and id != #{params[:id]}")
    
    if @check.length > 0
      
      @error = 1
      
    else
      
      @error = 0
      
    end
    
    render :layout=>false    
    
  end
  
  
  
  def create
    
    if current_user
      
      @check = Group.find_by_username(params[:group][:username])
      
      if @check
        
        flash[:message] = "Username Taken.  Please Choose Another."

        redirect_to "/groups/new"
        
      else
      
        @newgroup = Group.new(params[:group])
        @newgroup.save!
      
        SubscribedGroup.create!(:group_id=>@newgroup.id, :user_id=>current_user.id, :admin=>true)
    
        flash[:message] = "Settings Saved"

        redirect_to "/groups/#{@newgroup.id}/edit"
      end
      
    end
    
  end
  
  
  def destroy
    
    

      @groupinfo = Group.find(params[:id])
      
      if current_user
        
        @admin_groups = current_user.subscribed_groups.filter_group(@groupinfo.id).admins
        
        if @admin_groups.length > 0
        
        
            @groupinfo.destroy
        end
      end
      
      redirect_to "/my_escapes"
      
      
  end
  
  
  
end
