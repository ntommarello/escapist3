#require 'we_pay'
 
class PlansController < ApplicationController
  
  #include ActiveMerchant::Billing::Integrations
  
  
  include GeoKit::Geocoders
  before_filter :login_from_token, :only => [:featured]
  
  def featured
    
  end
  
  

  
  
  def paypal_ipn
    
    if request.post?
       notify = Paypal::Notification.new(request.raw_post)
       if notify.acknowledge
           if notify.complete?
             
             @user_id = params[:custom].to_i
             @plan_id = params[:item_number].to_i
             @qty = params[:quantity].to_i
             @amountpaid = params[:mc_gross]
             @email = params[:payer_email]

             #ugly temp hack. to be replaced by callback. Need to figre out QTY.
             check = SubscribedPlan.find_by_plan_id_and_user_id(@plan_id,@user_id)
             unless check
               SubscribedPlan.create(:plan_id => @plan_id, :user_id=>@user_id, :num_guests=>@qty)
               @user =  User.find(@user_id)
               @plan = Plan.find(@plan_id)

               if @plan.price and @plan.price > 0
                 if @user.discount_active == true
                   @user.discount_active = false
                   @user.save
                 end 
               end
               
               if @plan.group
                 if @plan.group.mailchimp_key and @plan.group.mailchimp_list
                   if @plan.group.mailchimp_key != "" and @plan.group.mailchimp_list != "" 
                     begin
                       h = Hominid::API.new(@plan.group.mailchimp_key)
                       h.list_subscribe(@plan.group.mailchimp_list, @user.email, {'FNAME' => @user.first_name, 'LNAME' => @user.last_name}, 'html', false, true, true, false)
                    rescue
                      
                    end
                  end
                 end
               end

               Postoffice.deliver_confirmation(@user,@plan)
              end
           end
       end
       render :nothing => true
     end
  end
  
  
  
  def wepay_callback
    
    #if event == "Received Money"
      
    #  o = OAuth::Consumer.new( WePay::CONSUMER_KEY, WePay::SHARED_SECRET, {
    #            :site => WePay::APIURL,
    #            :http_method => :post,
    #            :authorize_path => "/v1/oauth/authorize",
    #            :access_token_path => "/v1/oauth/access_token",
    #            :request_token_path => "/v1/oauth/request_token"})

        # Get a request token 
    #    request_token = o.get_request_token({
    #            :oauth_callback => "http://stomp.io/wepay_callback",
    #            :scheme => :query_string })

    #    access_token = request_token.get_access_token({:oauth_verifier => verifier})
        
    #    transacation = wp.get("/group/transactions/589165")
        
      
    #end
    
  end
  
  
  
  def create
    
    if current_user
      
      if params[:plan][:application_deadline] != ""
       date_and_time = '%m/%d/%Y'
       params[:plan][:application_deadline] = DateTime.strptime("#{params[:plan][:application_deadline]}", date_and_time)
      end 
      
      if params[:plan][:url_link] != ""
        params[:plan][:url_link] = "http://#{params[:plan][:url_link]}"
      end
       
      @plan = Plan.new(params[:plan])
    
      if params[:plan_price_radio].to_i == 1
        @plan.price = 0
      end
    
      @plan.featured = 1
      @plan.privacy = 1
    
      #if @group
      #  @plan.group_id = @group.id
      #end
      
      if @plan.group_id == 0
         @plan.group_id = nil
      end
     
      @plan.city_id = 99
      @plan.short_location = params[:plan][:url_name]
      
      if params[:plan][:url_name] == "Place, business, or landmark"
        @plan.url_name = nil
      end
    
      @plan.enable_comments = 1
      @plan.enable_sharing = 1
      @plan.enable_signups = 1
      
      if params[:plan][:enable_discount] == "on"
        @plan.enable_discount = true
      end
      

      
      if params[:application] == "2"
        @plan.application_required = true
      end
    

    
       combine_times
     
    
       if @plan.location != "Type anything Google Maps can figure out"
         loc = MultiGeocoder.geocode(@plan.location)
         if loc.success
           calc_closest_city(loc)
           @plan.city_id = @returned_city_id
           @plan.lat = loc.lat
           @plan.lng = loc.lng
         end

       end
       
    
    
    
      @plan.save!
      
      Host.create(:user_id => current_user.id, :plan_id => @plan.id, :admin=>true)
      
    
      redirect_to "/escapes/#{@plan.id}"
      
    end
    
    
  end
  
  
  def destroy
    
    

      @plan = Plan.find(params[:id])
      
      if current_user
        for host in @plan.organizers
          if host.id == current_user.id
            @plan.destroy
          end
        end
      end
      
      redirect_to "/"
      
      
  end
  
  
  def show
    
    @plan = Plan.find(:first, :conditions=>["id=?",params[:id]])
    @tickets = @plan.tickets.sort_by_type
    
     if !@plan
        redirect_to "/"
        return
      end
      
    @photos = Media.find(:all, :conditions=>["plan_id=? and media_type = ?",@plan.id,0], :order=>"sort_order asc")
    
   
    
    
    if @plan.location
      @cleaned_location = @plan.location.gsub(%r{</?[^>]+?>}, ' ').gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<br>/,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ')
    end
    
    
    @watched = false
    if current_user
      if current_user.has_watched?(@plan)
        @watched = true
      end
    end
    
    
    @real_edit_for_toggle = false
    
    
    #all hosts have access
    if current_user && @plan
      for host in @plan.hosts
       if host.user_id == current_user.id
          @author=true
          @real_edit_for_toggle = true
          @editable = true
          @extra_visibility = true
        end
      end
      
      #all group admins have access
      if @plan.group
        @admin = @plan.group.check_admin(current_user)
          if @admin
            @author=true
            @real_edit_for_toggle = true
            @editable = true
            @extra_visibility = true
          end
      end
      
      #all escapist admins have access
      if current_user.mod_level == 5
        @admin = true
        @editable = true
        @real_edit_for_toggle = true
        #@extra_visibility = false
      end
    end
    
    
    if cookies[:disable_edit]
      @editable = false
    end
    
    
    #redirect if password protected?
    if @plan.privacy == 3
      
      if cookies[:password] and (cookies[:password].downcase == @plan.password.downcase)
        redirect = false
      else
        redirect = true
      end
    else
      redirect = false
    end
    
    if @admin
      redirect = false
    end
    if @editable
      redirect = false
    end
    if redirect
      redirect_to "/?id=#{@plan.id}"
      return
    end
    
    
    
  if current_user && @plan.has_signedup?(current_user)
    @signedup = TRUE
    @signup_color = "Red"
  else
    @signedup = FALSE
    @signup_color = "Green"
  end



  
  





  end
  
  
  def download_ics
    
    
    @plan = Plan.find(params[:id])
    
    ical = RiCal.Calendar do |cal|
          cal.event do |event|
            event.description = "#{@plan.strip_short_desc}\n#{@plan.grab_url}"
            if @plan.start_time
              event.dtstart =  @plan.start_time.to_datetime
            end
            if @plan.end_time
              event.dtend = @plan.end_time.to_datetime
            end
            event.location = @plan.strip_location
            event.summary = @plan.strip_title
          end
        end
        send_data(ical.export, :filename=>"mycal.ics", :disposition=>"inline; filename=mycal.ics", :type=>"text/calendar")
        
  end
  
 
  
  
  def update
    
  

    @plan = Plan.find(params[:id])
    
    
    params[:plan].each  do |key, value| 
      unless key == "image"
        params[:plan][key] = CGI::unescape(value)
        params[:plan][key] = remove_end_breaks(params[:plan][key])
        
        if key == "application_deadline"
          if params[:plan][key] != ""
           date_and_time = '%m/%d/%Y'
           params[:plan][key] = DateTime.strptime("#{params[:plan][key]}", date_and_time)
          end
        end

        
      end 
    end
    
    #params[:plan][:short_desc] = CGI::unescape(params[:plan][:short_desc] )
    
    
    @plan.update_attributes(params[:plan])
    
    if @plan.transportation == ""
      @plan.transportation = nil
    end
    @plan.save
    
 
    redirect_to "/escapes/#{@plan.id}"
    
    

   
  end
  
  
  
  def geocode_plan
    #called from challenge create and challenge edit
    

            
    @lat = 0
    @lng = 0
    
    @cleaned_location = params[:location].gsub(%r{</?[^>]+?>}, ' ')
    @cleaned_location = @cleaned_location.gsub(/%3Cbr%3E/,' ')
    @cleaned_location = @cleaned_location.gsub(/%3Cdiv%3E/,' ')
    @cleaned_location = @cleaned_location.gsub(/%3C\/div%3E/,' ')
    @cleaned_location = @cleaned_location.gsub(/<div>/,' ')
    @cleaned_location = @cleaned_location.gsub(/\/div>/,' ')
    @cleaned_location = @cleaned_location.gsub(/%20/,' ')
    @cleaned_location = @cleaned_location.gsub(/&nbsp;/,' ')
    
    @cleaned_location = @cleaned_location.gsub(/%26nbsp/, ' ')
    
    loc = MultiGeocoder.geocode(@cleaned_location)
    if loc.success
      if params[:plan_id] != "0"  #set as zero on challenge create
        @plan = Plan.find(params[:plan_id])
        if @plan
          @plan.lat = loc.lat
          @plan.lng = loc.lng     
          @plan.save!
        end
      end
      @lat = loc.lat
      @lng = loc.lng
    end
    render :layout=>false    
  end
  
  
  def discover
    
    conditions = ""
    if @group #temp hack for snowriders
      if @group.id == 9  
        conditions = "or id in #{@snowriders}"
      end
    end
    
    if params[:dropdown_city_value]
      session[:dropdown_city_value] = params[:dropdown_city_value] || "Boston"
      session[:dropdown_city] = params[:dropdown_city] || "1"
    end
    
    t = Time.zone.now
     rounded_t = Time.local(t.year, t.month, t.day, 0, 0)
     
     
     
     
     
    if session[:dropdown_city_value].to_i == 1  #boston
      @origin = [42.358431,-71.059773]
    end
    if session[:dropdown_city_value].to_i == 2  #SF
      @origin = [37.77493,-122.419416] 
    end
    if session[:dropdown_city_value].to_i == 3  #NYC
      @origin = [40.7144,-74.006]
    end
    if session[:dropdown_city_value].to_i == 99  #globe
    
      if @group
        @plans = Plan.published.find(:all, :conditions=>["start_time >= ? and plans.group_id = #{@group.id} #{conditions}", rounded_t], :order=>"start_time asc", :include=>[:users])
      else
        @plans = Plan.public_published.find(:all, :conditions=>["start_time >= ?", rounded_t], :order=>"start_time asc", :include=>[:users])
      end
      
    else
 
 
       if @group  #todo: eventually allow private within a group
         
  
          
         @plans = Plan.published.find(:all, :conditions=>["start_time >= ? and plans.group_id = #{@group.id} #{conditions}", rounded_t],:order=>"start_time asc")
       else
         @plans = Plan.public_published.find(:all, :conditions=>["start_time >= ? and city_id=?", rounded_t,session[:dropdown_city_value].to_i ], :order=>"start_time asc", :include=>[:users])
          @ids = @plans.collect(&:id).to_s.sub('[','(')
           @ids = @ids.sub(']',')')
           if @plans.length > 0
             @other_plans = Plan.public_published.find(:all, :conditions=>["start_time >= ? and plans.id not in #{@ids}", rounded_t], :order=>"city_id desc, start_time asc", :include=>[:users])
          else
                @other_plans = Plan.public_published.find(:all, :conditions=>["start_time >= ?", rounded_t], :order=>"city_id desc, start_time asc", :include=>[:users])
            
          end
       end
       
      #@plans = Plan.public_published.find(:all, :conditions=>["start_time >= ? and city_id=?", rounded_t,session[:dropdown_city_value].to_i ], :order=>"start_time asc", :include=>[:users])

      #add in ones user is author for
       if current_user
         for plan in current_user.plans_authored
          if plan.published == false 
            @add_plan = Plan.find(:all, :conditions=>["id=?",plan.id])
            @plans = @plans + @add_plan
          end
         end
       end



      end
    
    if params[:dropdown_city_value]
      render :layout=>false
    end

   
  end
  
  
  def new
    
    
    if !current_user
      redirect_to "/"
    end
    
  end
  
  
  
  def edit_plan_date
    
    @plan = Plan.find(params[:plan_id])
    
    
    combine_times
    
    @plan.save
    
    @editable = true
    
    
    render :partial=>"plans/circle_date_small"
    
  end
  
  
  def combine_times
    
    if params[:start_time_date] != ""
      @start_hour = params[:start_time_hour]
      @end_hour = params[:end_time_hour]
      if params[:start_time_ampm] == "pm"
        @start_hour = @start_hour + 12
      end
      if params[:end_time_ampm] == "pm"
        @end_hour = @end_hour + 12
      end
    
    
      date_and_time = '%m/%d/%Y %H:%M %p'
  

    
    
    
      @plan.start_time = DateTime.strptime("#{params[:start_time_date]} #{params[:start_time_hour]}:#{params[:start_time_minute]} #{params[:start_time_ampm].upcase()}", date_and_time)
      @plan.end_time = DateTime.strptime("#{params[:end_time_date]} #{params[:end_time_hour]}:#{params[:end_time_minute]} #{params[:end_time_ampm].upcase()}", date_and_time)
    end
  end
  
  
  def my_escapes
    
    if !current_user
      redirect_to "/host_an_adventure"
      return
    end
    
    if !@group
      @escapist_plans = current_user.plans_authored.not_grouped.sort_time
      @admin_groups = current_user.subscribed_groups.admins
    else
      if current_user.mod_level > 4
        @admin_groups = SubscribedGroup.find(:all, :conditions=>"group_id=#{@group.id}", :group=>"group_id")
      else
        @admin_groups = current_user.subscribed_groups.filter_group(@group.id).admins
      end      
      
    end
    
    
    
    
  end
  
  
  def check_plan_password
    @plan = Plan.find(params[:plan][:id])
    
    if params[:plan][:password].downcase == @plan.password.downcase
      @id=@plan.id
      
      cookies[:password] =  @plan.password
      
      
    else
      @id=0
    end
    
    render :layout=>false 
    
    
  end
  
  def new_plan
    
     @plan = Plan.find(28)

      if !@plan
        redirect_to "/"
        return
      end


      if @plan.location
        @cleaned_location = @plan.location.gsub(%r{</?[^>]+?>}, ' ').gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<br>/,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ')
      end


      @watched = false
      if current_user
        if current_user.has_watched?(@plan)
          @watched = true
        end
      end


      @real_edit_for_toggle = false


      if current_user && @plan
        for host in @plan.hosts
         if host.user_id == current_user.id
            @author=true
            @real_edit_for_toggle = true
            @editable = true
            @extra_visibility = true
          end
        end
        if current_user.mod_level == 5
          @admin = true
          @editable = true
          @real_edit_for_toggle = true
          #@extra_visibility = false
        end
      end


      if cookies[:disable_edit]
        @editable = false
      end


      #redirect if password protected?
      if @plan.privacy == 3

        if cookies[:password] and (cookies[:password].downcase == @plan.password.downcase)
          redirect = false
        else
          redirect = true
        end
      else
        redirect = false
      end

      if @admin
        redirect = false
      end
      if @editable
        redirect = false
      end
      if redirect
        redirect_to "/?id=#{@plan.id}"
      end


  if current_user && @plan.has_signedup?(current_user)
    @signedup = TRUE
    @signup_color = "Red"
  else
    @signedup = FALSE
    @signup_color = "Green"
  end
  
    
  end
  
  
  
end
