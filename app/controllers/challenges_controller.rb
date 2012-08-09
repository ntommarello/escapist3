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
