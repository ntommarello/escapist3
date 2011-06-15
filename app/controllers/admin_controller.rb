class AdminController < ApplicationController
  include GeoKit
  
  
  
  def show
    
    

  end
  
  
  def index
    
    
    if !current_user or current_user.mod_level < 5
      redirect_to "/"
      
    else
      
      
      if params[:user_id]
        @user = User.find(params[:user_id])
        if @user.mod_level < 5
          sign_in  @user 
        end
      end
      
    
      if session[:dropdown_city_value] == "1"  #boston
       @origin = [42.358431,-71.059773]
      end
       if session[:dropdown_city_value] == "2"  #SF
          @origin = [37.77493,-122.419416]
       end
       if session[:dropdown_city_value] == "3"  #NYC
         @origin = [40.7144,-74.006]
       end


      if session[:dropdown_city_value] == "99"  #globe
        @users = User.paginate(:all,  :page => params[:page], :per_page=>100, :conditions=>"", :order=>"created_at desc")
        @total = User.find(:all)
        @total_pics = User.find(:all, :conditions=>"avatar_file_name != ''")
        @active_10_days = User.find(:all, :conditions=>"DATE_SUB(CURDATE(),INTERVAL 10 DAY) <= last_sign_in_at")
     else
       @users = User.paginate(:all,  :page => params[:page], :per_page=>200,  :order=>"created_at desc", :origin=>@origin, :within=>100)
       @total = User.find(:all,:origin=>@origin,:within=>100)
       @total_pics = User.find(:all, :conditions=>"avatar_file_name != ''", :origin=>@origin,:within=>100)
       @active_10_days = User.find(:all, :conditions=>"DATE_SUB(CURDATE(),INTERVAL 10 DAY) <= last_sign_in_at",:origin=>@origin,:within=>100)
     end

     @percent_active = @active_10_days.length.to_f / @total.length.to_f
     @percent_pics = @total_pics.length.to_f / @total.length.to_f
    end
     
  end

end
