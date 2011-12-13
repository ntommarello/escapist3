class AdminController < ApplicationController
  include GeoKit
   include ActionView::Helpers::NumberHelper
  
  
  def show
    
    

  end
  
  
  
  
  def export_guest
    
    require 'iconv' 
    require 'csv'
  
    conditions = "plan_id = #{params[:plan_id]}"

    #quick hack to sort correctly. Eventually remove.
     @tickets = TicketPurchase.find(:all)
    
     @tickets.each do |ticket|
      if ticket.user
        ticket.guest_last_name = ticket.user.last_name
        ticket.guest_first_name = ticket.user.first_name
      else
        if ticket.user_name
          ticket.user_name =  ticket.user_name.strip
          names = ticket.user_name.split
          if names.length > 1
             ticket.guest_last_name = names.pop.titleize
             ticket.guest_first_name = names.join(' ').titleize
          else
            ticket.guest_last_name = ticket.user_name.titleize
            ticket.guest_first_name = ""
          end
        end
      end
      ticket.save!
    end

    @tickets = TicketPurchase.find(:all, :conditions=>"#{conditions}", :order=>"guest_last_name asc", :include=>[:ticket])
    
  
    csv_string = CSV.generate do |csv|
      csv << ["Guest","Paid By","Ticket","Ticket Price"]
      
      @tickets.each do |ticket|
        
        payer_name = ""
        if ticket.payer_user_id
          payer = User.find(ticket.payer_user_id)
          payer_name = "#{payer.last_name}, #{payer.first_name}"
          
          ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
          payer_name = ic.iconv(payer_name + ' ')[0..-2]
        end
        
        
        if (ticket.guest_first_name and ticket.guest_first_name.length > 0)
          guest_name = "#{ticket.guest_last_name}, #{ticket.guest_first_name}"
        else
          if ticket.guest_last_name and ticket.guest_last_name.length > 0
            guest_name = "#{ticket.guest_last_name}"
          else
            guest_name = "Unknown Guest"
          end
        end
        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        guest_name = ic.iconv(guest_name + ' ')[0..-2]
        
        
        amount = number_with_precision (ticket.ticket.amount.to_f / 100.0), :precision => 2
        amount = "$#{amount}"
        
        csv << [guest_name,payer_name,ticket.ticket.title, amount]
      end
    end
    
    
    send_data csv_string, :type=>'text/csv; charset=iso-8859-1; header=present',
                          :disposition=>"attachment; filename=GuestList.csv"
                          
  end
  
  
  
  def index
    
    

    
    @admin = false;

    
    if @group and current_user
      @admin = @group.check_admin(current_user)
    end

    if current_user and current_user.mod_level == 5
      @admin = true
    end
    
    
    unless @admin
      redirect_to "/"
    end
    
      if params[:user_id]
        @user = User.find(params[:user_id])
        if @user.mod_level < 5
          sign_in  @user 
        end
      end
      
      
      
    
    
    
    if @group
      conditions = "plans.group_id=#{@group.id}"
    else
      conditions = "1=1"
    end
    
    t = Time.zone.now
    rounded_t = Time.local(t.year, t.month, t.day, 0, 0)
     
    @dropdown = Plan.find(:all, :conditions=>["#{conditions} and start_time >= ? ",rounded_t], :order=>"start_time ASC")
    
    if params[:plan_id] and params[:plan_id] != "0"
      conditions = "plans.id = #{params[:plan_id]}"
    end
    
    
    @plans = SubscribedPlan.find(:all, :joins=>:plan, :conditions=>"#{conditions}", :order=>"created_at desc", :include=>[:user, :plan])
    
    
  end
  
  
  
  
  
  def display_users
    
    
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
        @users = User.find(:all, :conditions=>"", :order=>"created_at desc")
        @total = User.find(:all)
        @total_pics = User.find(:all, :conditions=>"avatar_file_name != ''")
        @active_10_days = User.find(:all, :conditions=>"DATE_SUB(CURDATE(),INTERVAL 10 DAY) <= last_sign_in_at")
     else
       @users = User.find(:all,  :order=>"created_at desc", :origin=>@origin, :limit=>100)
       @total = User.find(:all,:origin=>@origin,:within=>100)
       @total_pics = User.find(:all, :conditions=>"avatar_file_name != ''", :origin=>@origin,:within=>100)
       @active_10_days = User.find(:all, :conditions=>"DATE_SUB(CURDATE(),INTERVAL 10 DAY) <= last_sign_in_at",:origin=>@origin,:within=>100)
     end

     @percent_active = @active_10_days.length.to_f / @total.length.to_f
     @percent_pics = @total_pics.length.to_f / @total.length.to_f
    end
     
  end

end
