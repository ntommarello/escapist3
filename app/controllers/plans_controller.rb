#require 'we_pay'

class PlansController < ApplicationController
  
  
  
  include GeoKit::Geocoders
  before_filter :login_from_token, :only => [:featured]
  
  def featured
    
  end
  
  
  def confirmation
      #ugly temp hack. to be replaced by callback
      check = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],params[:user_id])
      if check
      else
        SubscribedPlan.create(:plan_id => params[:plan_id], :user_id=>params[:user_id])
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
    
    #mobile bug
    if params[:version] == "1.0"
      if params[:maybe]
        @maybe = params[:maybe]
      else
        @maybe = 0
      end

       check = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
       if check
         check.maybe = @maybe
         check.save!
       else
         SubscribedPlan.create(:plan_id => params[:plan_id], :user_id=>current_user.id, :maybe=>@maybe)
       end
    end
  end
  
  
  def destroy
    
    #mobile bug
    if params[:version] == "1.0"
      @splan = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
       @splan.destroy
    end
    
  end
  
  
  def show
    
    @plan = Plan.find(:first, :conditions=>["id=?",params[:id]])
    
    if !@plan
      redirect_to "/"
      return
    end
    
    
    if @plan.location
      @cleaned_location = @plan.location.gsub(%r{</?[^>]+?>}, ' ').gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<br>/,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ')
    end
    
    
    
    if current_user && @plan
      for host in @plan.hosts
       if host.user_id == current_user.id
          @author=true
          @editable = true
          @extra_visibility = true
        end
      end
      if current_user.mod_level == 5
        @admin = true
        @editable = true
        @extra_visibility = false
      end
    end
    
  end
  
  
  def update
    
  

    @plan = Plan.find(params[:id])
    
    @plan.update_attributes(params[:plan])
    
    if @plan.transportation == ""
      @plan.transportation = nil
    end
    @plan.save
    
 
    redirect_to "/plans/#{@plan.id}"
    
    

   
  end
  
  
  
  def geocode_plan
    #called from challenge create and challenge edit
    
    @lat = 0
    @lng = 0
    
    @cleaned_location = params[:location].gsub(%r{</?[^>]+?>}, ' ')
    @cleaned_location = @cleaned_location.gsub(/%3Cbr%3E/,' ')
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
  
  
  def schedule
    
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
       @plans = Plan.find(:all, :conditions=>["start_time >= ?", rounded_t], :order=>"city_id desc, start_time asc", :include=>[:user, :users])
    else
 
      @plans = Plan.find(:all, :conditions=>["start_time >= ?", rounded_t], :origin => @origin, :within=>100, :order=>"start_time asc", :include=>[:user, :users])

      @ids = @plans.collect(&:id).to_s.sub('[','(')
      @ids = @ids.sub(']',')')
      @other_plans = Plan.find(:all, :conditions=>["start_time >= ? and plans.id not in #{@ids}", rounded_t], :order=>"city_id desc, start_time asc", :include=>[:user, :users])
    end
    
    if params[:dropdown_city_value]
      render :layout=>false
    end

   
  end
  
  
  def new
    
  end
  
  
  
end
