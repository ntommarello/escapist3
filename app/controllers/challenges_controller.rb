class ChallengesController < ApplicationController
 
 include GeoKit::Geocoders
 require 'titlecase'
 
 def userChallengeSession
    #Set Defaults if New User
     if session[:dropdown_city_value].nil?
       session[:dropdown_city] = "Boston"
       session[:dropdown_city_value] = 1
     end
     if session[:filter_weather_value].nil?
       session[:filter_weather_value] = 99
       session[:filter_weather] = "Either"
     end
     if session[:filter_vetted].nil?
       session[:filter_vetted] = 1
     end
     if session[:filter_budget_low_value].nil?
       session[:filter_budget_low] = "Free"
       session[:filter_budget_low_value] = 1
     end
     if session[:filter_budget_high_value].nil?
       session[:filter_budget_high] = "$300+"
       session[:filter_budget_high_value] = 6
     end
     if session[:filter_diff_low_value].nil?
       session[:filter_diff_low] = "Easy"
       session[:filter_diff_low_value] = 1
     end
     if session[:filter_diff_high_value].nil?
       session[:filter_diff_high] = "Insane"
       session[:filter_diff_high_value] = 5
     end

     if session[:challenge_sort].nil?
        session[:challenge_sort] = "Awesome Sauce"
     end
  end
 
  def index
    userChallengeSession
    
    #check to see if filter callout should be defaulted to open
    if session[:filter_weather_value].to_i != 99 or (session[:filter_diff_low_value].to_i != 1 or session[:filter_diff_high_value].to_i != 5)
      @displayAdvanced = "block"
    else
      @displayAdvanced = "none"
    end  
    
    if session[:filter_budget_low_value].to_i == 1 and session[:filter_budget_high_value].to_i == 6
      @displayBudget = "none"
    else
      @displayBudget = "block"
    end
  
    #because of infinite scroll
    if params[:page] || params[:iphone] || params[:mobile]
      refresh_challenges
    end
  end

  def show
    
    #direct link from email on comments
    if !current_user
      if params[:user_credentials]
        @user = User.find_by_authentication_token(params[:user_credentials])
        sign_in @user
      end
      
      if params[:auto_login_token]
        @user = User.find_by_authentication_token(params[:auto_login_token])
        sign_in @user
      end
    end

    @challenge = Challenge.find(params[:id])
    
    @author=false
    if @challenge.author_id == 0 or @challenge.author_id.nil?
      @author=true
      @editable = true
      @extra_visibility = true
    end
    
    if current_user && @challenge
       if @challenge.author_id == current_user.id
          @author=true
        end
      if @challenge.author_id == current_user.id or current_user.mod_level == 5
        @editable = true
        @extra_visibility = true
      end
      if current_user.mod_level == 5
        @admin = true
        @extra_visibility = false
      end
    end
    
    
    @related_challenges = ""
    if @challenge.achievement
      if @challenge.achievement.category
        @related_challenges =  Challenge.find(:all, :select=>"challenges.*", :joins=>:achievement, :conditions=>["published=? and challenges.id != ? and achievements.category_id = ? and distance < 100",true,@challenge.id, @challenge.achievement.category.id],:origin => [@challenge.lat,@challenge.lng], :order=>"distance asc", :limit=>3)
      end
    end
    
    
    
    @note = ""
    @addBucket = false
    @stomped = false
    @disliked = "0"
    if current_user
      @checkBucket = SubscribedChallenge.find(:first, :conditions=>"user_id=#{current_user.id} and challenge_id=#{@challenge.id}")
      if @checkBucket
        @addBucket = true
        @note = @checkBucket.note
        @subscribed_id =  @checkBucket.id
      end
      if current_user.has_completed_challenge?(@challenge)
        @stomped = true
      end
      
      @checkdisliked = Dislike.find(:first, :conditions=>"user_id=#{current_user.id} and challenge_id=#{@challenge.id}")
      if @checkdisliked
        @disliked = "1"
      end
    else
      
      if cookies[:challenges]
        @bucket_ids = cookies[:challenges].split(',').map(&:to_i)
      end
      if @bucket_ids
  			if @bucket_ids.include?(@challenge.id)
  		  		@addBucket=true
  			end
  		end
  		
  		  if cookies[:dislikes]
          @dislikes = cookies[:dislikes].split(',').map(&:to_i)
        end
        if @dislikes
      		if @dislikes.include?(@challenge.id)
      	  		  @disliked = "1"
      		end
      	end
      	if cookies[:stomped]
          @stomps = cookies[:stomped].split(',').map(&:to_i)
        end
        if @stomps
      		if @stomps.include?(@challenge.id)
      	  		 @stomped = true
      		end
      	end
      		
      
    end
    
    #temp hack - need to strip html for google map link.  
    if @challenge.location
      @cleaned_location = @challenge.location.gsub(%r{</?[^>]+?>}, ' ').gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<br>/,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ')
    end
    

    generate_log(@challenge.id)
    
    
   
   #which invite box?
    @source = "challenge_invite"
		if !current_user and @challenge.author_id == nil
			@source = "challenge_author"
		elsif current_user and @challenge.published ==false and @challenge.author_id == current_user.id
			@source = "challenge_author"
		end
		
		#show invite box display?
		@showInviteBox = "none"
		if @source == "challenge_author" 
		  @showInviteBox = "block"
		end
		if @checkBucket
		   @showInviteBox = "block"
		end

		
  end


  
  def refresh_challenges
    userChallengeSession
  
    #TODO:  browser cache for ajax back button shit, for faster refresh. No clue what I'm doing.
    #cacheTime = Time.rfc2822(@request.env["HTTP_IF_MODIFIED_SINCE"]) rescue nil
    #if cacheTime and cacheTime >= Time.now 
      #return render :nothing => true, :status => 304
    #end
    #cache_until = Time.now+5.minutes
    #response.headers['Last-Modified'] = cache_until.httpdate
          
    #response.headers['Cache-Control'] = 'public, max-age=300'
    
    #called from  challenges index via ajax
    
    params[:page] = "1" if params[:page].blank?
    
    if params[:iphone]
      if params[:auto_login_token]
        if !current_user
          user = User.find_by_authentication_token(params[:auto_login_token])
          sign_in user
        end
        session[:lat] = current_user.lat
        session[:lng] = current_user.lng
      end
    end
    
    #check params to see if filtering is being done from ajax calls
    if params[:challenge]
      if params[:challenge][:city]
        session[:dropdown_city] = params[:challenge][:city]
        session[:dropdown_city_value] = params[:challenge][:city_value]
      end
      if params[:challenge][:sort]
        session[:challenge_sort] = params[:challenge][:sort]
      end
    end
      
    if params[:challenge_weather_value]
      session[:filter_weather_value] = params[:challenge_weather_value]
      session[:filter_weather] = params[:challenge_weather]
    end
        
    if params[:filter_vetted]
      session[:filter_vetted] = params[:filter_vetted]
    end

    if params[:filter_budget_low_value] 
      session[:filter_budget_low_value] = params[:filter_budget_low_value]
      session[:filter_budget_low] = params[:filter_budget_low]
    end

    if params[:filter_budget_high_value] 
      session[:filter_budget_high_value] = params[:filter_budget_high_value]
      session[:filter_budget_high] = params[:filter_budget_high]
    end
      
    if params[:filter_diff_low_value] 
      session[:filter_diff_low_value] = params[:filter_diff_low_value]
      session[:filter_diff_low] = params[:filter_diff_low]
    end

    if params[:filter_diff_high_value] 
      session[:filter_diff_high_value] = params[:filter_diff_high_value]
      session[:filter_diff_high] = params[:filter_diff_high]
    end
      
    if params[:filter_category]
      session[:filter_category] = params[:filter_category]
    end

    if params[:lat] && params[:lng]
      session[:lat] = params[:lat]
      session[:lng] = params[:lng]
    end
      
    @diffLow = 0
    if (session[:filter_diff_low_value].to_i == 1)
      @diffLow = 0
    end
    if (session[:filter_diff_low_value].to_i == 2)
      @diffLow = 2
    end
    if (session[:filter_diff_low_value].to_i == 3)
      @diffLow = 3
    end
    if (session[:filter_diff_low_value].to_i == 4)
      @diffLow = 5
    end
    if (session[:filter_diff_low_value].to_i == 5)
      @diffLow = 6
    end
      
    @diffHigh = 99
    if (session[:filter_diff_high_value].to_i == 1)
      @diffHigh = 1
    end
    if (session[:filter_diff_high_value].to_i == 2)
      @diffHigh = 2
    end
    if (session[:filter_diff_high_value].to_i == 3)
      @diffHigh = 4
    end
    if (session[:filter_diff_high_value].to_i == 4)
      @diffHigh = 5
    end
    if (session[:filter_diff_high_value].to_i == 5)
      @diffHigh = 99
    end

    #Build Proper Query
    conditionString = ""
    if session[:dropdown_city_value].to_i != 99   #99 indicates globe or not selected
      conditionString = "#{conditionString} and city=#{session[:dropdown_city_value]}"
    end
    if session[:filter_weather_value].to_i != 99
      conditionString = "#{conditionString} and (weather=#{session[:filter_weather_value]} || weather=3)"  #1=hot.2=cold.3=could be either.
    end
      
    if session[:filter_vetted].to_i == 1
      conditionString = "#{conditionString} and vetted = 1"
    end
      
    conditionCatString = ""
    if session[:filter_category]
      if session[:filter_category] == "sports"
        conditionCatString = " and challenges.category_id in (1,11)"
      end
      if session[:filter_category] == "fun"
        conditionCatString = " and challenges.category_id=2"
      end
      if session[:filter_category] == "outdoor"
        conditionCatString = " and challenges.category_id in (4,10)"
      end
      if session[:filter_category] == "food"
        conditionCatString = " and challenges.category_id in (5,6,7)"
      end
      if session[:filter_category] == "sightseeing"
        conditionCatString = "and challenges.category_id in (8,9,14)"
      end
      if session[:filter_category] == "classes"
        conditionCatString = "and challenges.category_id=13"
      end
    end

    conditionString = "#{conditionString} and budget between #{session[:filter_budget_low_value].to_i} and #{session[:filter_budget_high_value].to_i} and points between #{@diffLow} and #{@diffHigh}"  
    
    if current_user
      #@bucket = SubscribedChallenge.find(:all, :conditions => ["completed=? and user_id=?", false, current_user.id])
      @bucket_ids = SubscribedChallenge.all(:select => "challenge_id", 
              :conditions => "user_id = #{current_user.id} and completed !=1").collect(&:challenge_id)
      
      @done_ids = SubscribedChallenge.all(:select => "challenge_id", 
                      :conditions => "user_id = #{current_user.id} and completed = 1").collect(&:challenge_id)  
             
      #if ids.length > 0
        #conditionString = "#{conditionString} and challenges.id not in (#{ids})"  
      #end
      
      ids2 = Dislike.all(:select => "challenge_id", 
              :conditions => "user_id = #{current_user.id}").collect(&:challenge_id).join(",")
      if ids2.length > 0
        conditionString = "#{conditionString} and challenges.id not in (#{ids2})"  
      end
    else
      if cookies[:challenges]
        @bucket_ids = cookies[:challenges].split(',').map(&:to_i)
      end
      if cookies[:stomped]
        @done_ids = cookies[:stomped].split(',').map(&:to_i)
      end
      if cookies[:dislikes]
        ids = cookies[:dislikes].split(',').map(&:to_i)
        if ids.length > 0
          conditionString = "#{conditionString} and challenges.id not in (#{cookies[:dislikes]})"  
        end
      end
      
    end
   
    if session[:challenge_sort] == "Popularity"
      #ToDO:  Should decide if popularity means completed, added to todo, or both
      #@sort = "subscribed_challenges_count DESC"
      #TEMP HACK
      @sort = "challenges.sum_completed DESC"
    end
    if session[:challenge_sort] == "Distance"
      @sort = "distance ASC"
    end
    if session[:challenge_sort] == "Difficulty"
      @sort = "points DESC"
    end
    if session[:challenge_sort] == "New"
      @sort = "challenges.created_at DESC"
    end
    if session[:challenge_sort] == "Awesome Sauce"
      if session[:dropdown_city_value].to_i != 99  
        @sort = "challenges.editor_pick DESC, sum_todo_list DESC, subscribed_challenges_count DESC"
      else
        @sort = "distance desc"
      end
    end
      
    #hack because of infinite scroll & back button.  Reload all results on refresh
    if params[:init]
      @limit = params[:page].to_i * 21
      params[:page] = 1
    end

    @challenges = Challenge.paginate(:all, :page => params[:page], :per_page=>@limit, :conditions=>"published=1 #{conditionString} #{conditionCatString}", :include=>[:user,:achievement], :origin => [session[:lat],session[:lng]], :order=>@sort)
     
    categories=  Challenge.find(
               :all, 
               :select => 'count(*) num, category_id', 
               :group => 'category_id', 
               :conditions => "published=1 #{conditionString}")
    
    @fun = 0
    @sports=0
    @outdoor=0
    @food=0
    @sightseeing=0
    @dogood=0
    @classes=0
    @total = 0
    for category in categories
      @total = @total + category.num.to_i
      if category.category_id.to_i == 2
        @fun = @fun + category.num.to_i
      end 
      if category.category_id.to_i == 1 or category.category_id.to_i == 11
        @sports = @sports + category.num.to_i
      end
      if category.category_id.to_i == 4 or category.category_id.to_i == 10
        @outdoor = @outdoor + category.num.to_i
      end
      if category.category_id.to_i == 5 or category.category_id.to_i == 6 or category.category_id.to_i == 7
        @food = @food + category.num.to_i
      end
      if category.category_id.to_i == 8 or category.category_id.to_i == 9 or category.category_id.to_i == 14
        @sightseeing = @sightseeing + category.num.to_i
      end
      if category.category_id.to_i == 12
        @dogood = @dogood + category.num.to_i
      end
      if category.category_id.to_i == 13
        @classes = @classes + category.num.to_i
      end
    end
    @all = @total
      
    #reset category filter if no results within that category 
    if @challenges.length == 0 and categories.length > 0
      @challenges = Challenge.paginate(:all, :page => params[:page], :per_page=>@limit, :conditions=>"published=1 #{conditionString}", :include=>[:user,:achievement], :origin => [session[:lat],session[:lng]], :order=>@sort)
      session[:filter_category] = "any"
    end
          
    unless params[:iphone] || params[:mobile]
      render :partial=>"challenges/refresh_challenges", :locals=>{:source=>"challenges"}
    end
  end
   
  def create
     
    @challenge = Challenge.new(params[:challenge])
    
    #mod_level 5 is admin.  
    if current_user && current_user.mod_level == 5
      #@challenge.vetted = 1
      @challenge.author_id = current_user.id
    elsif current_user
      @challenge.author_id = current_user.id
    end
    
    
    if @challenge.details == "" or @challenge.details.nil?
      @challenge.details = "Insert some details.  Why is this fun?  How can you do it?  Write a short paragraph."
    end
    if @challenge.title == ""
      @challenge.title = "Insert Title"
    end
    @challenge.title = @challenge.title.titlecase
    
    @challenge.points = 1
    @challenge.budget = 1
    
    if @challenge.proof.nil?
      @challenge.proof = "Upload a photo or video that shows you stomped this challenge"
    end
    if @challenge.location == "" or @challenge.location.nil?
      @challenge.location = "Type in the address. Google shall find."
      @challenge.lat = 0
      @challenge.lng = 0
    else
      if @challenge.location != "Current Location"
        loc = MultiGeocoder.geocode(@challenge.location)
        if loc.success
          calc_closest_city(loc)
          @challenge.city = @returned_city_id
          @challenge.lat = loc.lat
          @challenge.lng = loc.lng
        end
        
      end
    end
    
    if current_user
      if @challenge.location == "Current Location"
        @challenge.lat = current_user.lat
        @challenge.lng = current_user.lng
        @challenge.location = current_user.location_city
        
        loc = MultiGeocoder.geocode(current_user.location_city)
        if loc.success
          calc_closest_city(loc)
          @challenge.city = @returned_city_id
        end
      end      
    end
    
    @challenge.save!
    
    if params[:ididthis]
      if params[:ididthis] == "1"
        if current_user
          @completedChallenge = SubscribedChallenge.create(:challenge_id=>@challenge.id, :user_id=>current_user.id, :completed=>true)
          @completedChallenge.completed = true
          @completedChallenge.date_completed_on = Time.now
          @completedChallenge.points_awarded = @challenge.points
          @completedChallenge.proof = params[:challenge][:photo]
           @completedChallenge.save!

            current_user.score = current_user.score + @challenge.points
            current_user.save!
        end
      end
    end
    
    
    

    
    if !current_user
      if cookies[:challenges_created]
        if cookies[:challenges_created].blank?
          cookies[:challenges_created] = @challenge.id
        else
          cookies[:challenges_created] = cookies[:challenges_created] << ",#{@challenge.id}"
        end
      else
        cookies[:challenges_created] = @challenge.id
      end
    end
    
    if params[:mobile]
      respond_to do |format|
          format.xml { render }
          format.json { render :json => @challenge.to_json }
      end
    else
      	render :partial => "/challenges/challenge_card", :locals=>{:source=>"New", :challenge=>@challenge, :i=>-1}
      #redirect_to "/challenges/#{@challenge.id}-#{@challenge.title.parameterize}"
    end

    
    

  end




  def update
    
  

    @challenge = Challenge.find(params[:id])
    @challenge.update_attributes(params[:challenge])
    
    
    if params[:achievementname]
      @ach = Achievement.find_by_name(params[:achievementname])
      if @ach
        @challenge.achievement_id = @ach.id
      end
    end
      
     if @challenge.author_id == 0 or @challenge.author_id.nil?
        @challenge.save
     else
       if current_user
         if current_user.mod_level == 5 or @challenge.author_id == current_user.id
           @challenge.save
         end
       end
     end
     

    if params[:redirect_create]
      redirect_to "/challenges/new"
    else
      redirect_to "/challenges/#{@challenge.id}-#{@challenge.title.parameterize}"
    end
    
  end



  def destroy
    
    
    @challenge = Challenge.find(params[:challenge_id])
    @proofs = SubscribedChallenge.find_by_challenge_id(params[:challenge_id])
    
    if current_user
      if current_user.id == @challenge.author_id
        if @proofs
          @challenge.author_id = 0
          @challenge.save!
        else
          @challenge.destroy
        end
      end
    else
     if  @challenge.author_id == 0 or @challenge.author_id.nil?
       CreateCookie_Delete()
       @challenge.destroy
      end
    end 
  end



  def CreateCookie_Delete
    if  cookies[:challenges_created]
      @challenges =  cookies[:challenges_created].split(",")
      @challenges_modify = "0"
      for var in @challenges
        if var != params[:challenge_id]
  		    @challenges_modify = "#{@challenges_modify},#{var}"
  		  end
  	  end
  	  cookies[:challenges_created] = @challenges_modify
  	end
  end
  



  def geocoder
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
      calc_closest_city(loc)
      @city = @returned_city_id
      if params[:challenge_id] != "0"  #set as zero on challenge create
        @challenge = Challenge.find(params[:challenge_id])
        if @challenge
          @challenge.lat = loc.lat
          @challenge.lng = loc.lng     
          @challenge.city = @city
          @challenge.save!
        end
      end
      @lat = loc.lat
      @lng = loc.lng
    end
    render :layout=>false    
  end


  def generate_log(id)
    @completed  = SubscribedChallenge.find(:all, :conditions=>"challenge_id=#{id} and completed=1 and proof_file_name !=''", :include=>[:user, :challenge, {:likes => :user}])
    @bucket  = SubscribedChallenge.find(:all, :conditions=>"challenge_id=#{id} and completed=0 and users.avatar_file_name !=''", :include=>[:user, :challenge, {:likes => :user}])
    @plans = Plan.find(:all, :conditions=>"challenge_id=#{id}", :joins=>:challenge)

   if @completed.length > 0 or @bucket.length > 0 or @plans.length > 0
     @showtabs = true
    else
      @showtabs = false
    end
    
    
  end


  #called from challenges > planning tab
  def ajax_redraw_planning_box
   
   generate_log(params[:id])
   @challenge = Challenge.find(params[:id])
    render :partial=>"challenges/loop_log"
    
  end


  def mobile_livesearch
    @search_text = params[:search_text]
    lat = (session[:lat] / 180.0) * Math::PI 
    lng = (session[:lng] / 180.0) * Math::PI
    @conditions = {:published=>1}
     
    @challenges = Challenge.search "#{@search_text}*", :geo => [lat,lng],  :match_mode => :any, :with=> @conditions, :limit=>10   

  end
  
  
  
  def new
     @my_challenges = ""
     
    if current_user and current_user.mod_level = 5
      @admin = true
    else
      @admin = false
    end
    
    @my_challenges = []
    if current_user
      @my_challenges = Challenge.find(:all, :select=>"challenges.*, (select count(*) from subscribed_challenges where completed=1 and challenge_id=challenges.id) as stomped, (select count(*) from subscribed_challenges where completed!=1 and challenge_id=challenges.id) as bucketed", :conditions=>["author_id=?",current_user.id], :order=>"created_at DESC")
    else
      if cookies[:challenges_created]
        @var =  cookies[:challenges_created].split(",")
        @tokens="0"
  		  for var in @var
  			  @tokens = "#{@tokens},#{var}"
  		  end

        @my_challenges = Challenge.paginate(:all,  :page => params[:page], :select=>"challenges.*, 0 as bucketed, 0 as stomped", :conditions=>"challenges.id in (#{@tokens})")
        @my_challenges = @my_challenges.reverse
      end
    end
    
    @sum_bucket = 0
    @sum_stomped = 0
    @sum_curation = 0
    for challenge in  @my_challenges 
      @sum_bucket = @sum_bucket +challenge.bucketed.to_i
      @sum_stomped = @sum_stomped +challenge.stomped.to_i
      if challenge.vetted
        @sum_curation = @sum_curation + 1
      end
      if challenge.editor_pick
        @sum_curation = @sum_curation + 1
      end
      
    end
    @curation_points = @sum_stomped + @sum_bucket + (@sum_curation*3)
    
    
    
  end


  def create_search_results

    @search_text = params[:search_text]
  
    @bad_words = Hash.new
    @bad_words[:go] = "" 
    @bad_words[:visit] = "" 
    @bad_words[:try] = "" 
    @bad_words[:explore] = "" 
    @bad_words[:build] = "" 
    @bad_words[:make] = ""
    @bad_words[:take] = "" 
    @bad_words[:a] = "" 
    @bad_words[:at] = "" 
    @bad_words[:with] = ""
    @bad_words[:the] = ""
    @bad_words[:in] = ""
    @bad_words[:on] = ""
    @bad_words[:of] = ""
    @bad_words[:and] = ""
    @bad_words[:to] = ""

    @seperated_words =  @search_text.split(" ") # seperate content by spaces
    @cleaned_string = ""

    for word in @seperated_words
     @bad_words.each do |bad_word, replacement|
      if word.upcase == bad_word.to_s.upcase # if the word we're looking at is bad
       word = replacement # replcae the word 
       else # the word is we're looking at is okay
       end
     end    
      @cleaned_string << word + " "
     end
    
    
    @conditions = {:published=>1}
     
    @searchResults = Challenge.search "#{@cleaned_string}", :star=>true, :match_mode => :any, :with=> @conditions, :limit=>5, 
    :field_weights => {
      :title => 5,
      :details    => 1
    }   

    render :partial=>"challenges/create_live_search"
  end

end
