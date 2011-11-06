class SubscribedChallengesController < ApplicationController
  require 'open-uri'
  #require 'bitly'

  before_filter :login_from_token
  
  def bucket_list
    @editable = true
    #todo: non-loggedin version
    if current_user
      #@challenges = Challenge.paginate(:all,  :page => params[:page], :select=>"challenges.*", :joins=>:subscribed_challenges, :conditions=>"completed=0 and subscribed_challenges.user_id=#{current_user.id}", :origin => [session[:lat],session[:lng]], :order=>"distance asc", :include=>[:user,:achievement])
   
      if params[:sort] == "distance"
        @order = "distance ASC"
        @per = 200
      else
        @order = "isnull asc, subscribed_challenges.goal_date asc, subscribed_challenges.updated_at desc"
        @per = 21
      end

      if params[:lat] && params[:lng]
        session[:lat] = params[:lat]
        session[:lng] = params[:lng]
      end
    
      @bucket_list_visual = Challenge.paginate(:all,  :page => params[:page], :per_page=>@per, :select=>"challenges.*, subscribed_challenges.goal_date IS NULL AS isnull,subscribed_challenges.goal_date, subscribed_challenges.updated_at, subscribed_challenges.id as log_id, subscribed_challenges.note as note", :joins=>:subscribed_challenges, :conditions=>"completed=0 and subscribed_challenges.user_id=#{current_user.id}", :origin => [session[:lat],session[:lng]], :order=>@order, :include=>[:user,:achievement])
      @bucket_list  = SubscribedChallenge.find(:all, :select=>"subscribed_challenges.*, subscribed_challenges.goal_date IS NULL AS isnull", :conditions=>"user_id=#{current_user.id} and completed !=1", :include=>[:user, :challenge, {:likes => :user}], :order=>"isnull asc, subscribed_challenges.goal_date asc, subscribed_challenges.updated_at desc")
      
      @user = current_user
      
    else
      if cookies[:challenges]
        @var =  cookies[:challenges].split(",")
        @tokens="0"
  		  for var in @var
  			  @tokens = "#{@tokens},#{var}"
  		  end

        @challenges = Challenge.paginate(:all,  :page => params[:page], :select=>"challenges.*", :conditions=>"challenges.id in (#{@tokens})", :origin => [session[:lat],session[:lng]], :order=>"distance asc", :include=>[:user,:achievement])
        @completed_challenges = ""
      end
    end
    
    
    @toggleBucket = "card"

    if cookies[:toggleBucket]
     @toggleBucket = cookies[:toggleBucket] 
    end
    
    
    respond_to do |format|
        format.xml { render }
        format.json { render }
         format.html { render }
    end
    
    
    
  end
  
  
  def create
    
    @challenge = Challenge.find(params[:challenge_id])
                    
    if params[:completed] #proof submit
      
      if current_user
        #user's don't need to add to bucket before submitting proof
        @subscribed_challenge = SubscribedChallenge.find_by_user_id_and_challenge_id(current_user.id,params[:challenge_id])
      
        if @subscribed_challenge
          challengecomplete
        else
           @subscribed_challenge = SubscribedChallenge.create(:challenge_id=>params[:challenge_id], :user_id=>current_user.id, :completed=>true, :date_completed_on=>Time.now)
           challengecomplete
        end
      else 
        StompCookie_Write()
      end
      
      if !params[:mobile]
        redirect_to(:back)
      end
      
    else   #add to bucket
   
      if !current_user
        ChallengeCookie_Write()
      else
        unless @subscribed_challange = SubscribedChallenge.find_by_user_id_and_challenge_id(current_user.id,params[:challenge_id])
          @subscribed_challenge = SubscribedChallenge.create(:challenge_id=>params[:challenge_id], :user_id=>current_user.id, :completed=>false)
 
          if current_user.autopost_facebook_bucket
            if current_user.authentications.facebook[0]
              begin
                @graph = Koala::Facebook::GraphAPI.new(current_user.authentications.facebook[0].token)
                @graph.put_wall_post("I added a Stomp.io challenge to my Bucket List!  Come join me!",{:description=>@challenge.details, :name => @challenge.title, :picture=>@challenge.photo.url(:thumb_214), :link => "http://#{APP_URL}/challenges/#{@challenge.id}-#{@challenge.title.parameterize}"})
              rescue
                
              end
            end
          end
          
          if current_user.autopost_twitter_bucket
            if current_user.authentications.twitter[0]
              begin
               # bitly = Bitly.new(BITLY_ID,BITLY_KEY)
                #page_url = bitly.shorten("http://#{APP_URL}/challenges/#{@challenge.id}-#{@challenge.title.parameterize}")
                #oauth = Twitter::OAuth.new(TWITTER_KEY, TWITTER_SECRET)
                #oauth.authorize_from_access(current_user.authentications.twitter[0].token, current_user.authentications.twitter[0].secret)
                #client = Twitter::Base.new(oauth)
                #client.update("I want to do this: #{@challenge.title}. Join me! #{page_url.shorten} #StompIO")
              rescue
                
              end
            end
          end
          
          
        end
      end
    end
    
  end


  def destroy

    if !current_user
      ChallengeCookie_Delete()
      StompCookie_Delete()
    else
      @delete = SubscribedChallenge.find(:first, :conditions=>"user_id=#{current_user.id} and challenge_id=#{params[:challenge_id]}")
      
      if @delete and @delete.completed == true
        @challenge = Challenge.find(params[:challenge_id])
        current_user.score = current_user.score - @challenge.points
        current_user.save!
        @deleteAchieve = SubscribedAchievement.find_by_user_id_and_achievement_id(current_user.id,@challenge.achievement_id)
        if @deleteAchieve
          if @deleteAchieve.level < 2
            @deleteAchieve.destroy
          else
            @deleteAchieve.level = @deleteAchieve.level - 1
          end
        end

        
      end
      
      @delete.destroy
      
      
    end
  end



  def panda_callback
    @encoding_data =  Panda.get("/videos/#{params[:panda_video_id]}/encodings.json")
    @thumbnail_id = @encoding_data[0]['id']
    image_url = "http://s3.amazonaws.com/trek.io.video/#{@thumbnail_id}_1.jpg"
    @subscribed_challenge = SubscribedChallenge.find_by_panda_video_id(params[:panda_video_id])
    if @subscribed_challenge
      @subscribed_challenge.proof = image_url
      @subscribed_challenge.save!
    end
  end


  def challengecomplete
  

    @subscribed_challenge.points_awarded = @challenge.points
    if params[:video]
      @subscribed_challenge.panda_video_id = params[:video][:panda_video_id]
    end
    if params[:challenge]
      @subscribed_challenge.update_attributes(params[:challenge])
      @subscribed_challenge.date_completed_on = Time.now
    end
    @subscribed_challenge.completed = true
    @subscribed_challenge.save!
    
    
    if !params[:mobile]
    
      if current_user.autopost_facebook_completed
        if current_user.authentications.facebook[0]
          begin
            @graph = Koala::Facebook::GraphAPI.new(current_user.authentications.facebook[0].token)
            @graph.put_wall_post("I completed a Stomp.io challenge!",{:description=>@challenge.details, :name => @challenge.title, :picture=>@subscribed_challenge.proof.url(:thumb_214), :link => "http://#{APP_URL}/challenges/#{@challenge.id}-#{@challenge.title.parameterize}"})
          rescue
          
          end
        end
      end
    
      if current_user.autopost_twitter_completed
        if current_user.authentications.twitter[0]
          begin
            bitly = Bitly.new(BITLY_ID,BITLY_KEY)
            page_url = bitly.shorten("http://#{APP_URL}/challenges/#{@challenge.id}-#{@challenge.title.parameterize}")
            oauth = Twitter::OAuth.new(TWITTER_KEY, TWITTER_SECRET)
            oauth.authorize_from_access(current_user.authentications.twitter[0].token, current_user.authentications.twitter[0].secret)
            client = Twitter::Base.new(oauth)
            client.update("I finished a #StompIO challenge: #{@challenge.title}. Check it out! #{page_url.shorten}")
          rescue
          
          end
        end
      end
    
    end
    
    if params[:challenge]
      if params[:challenge][:proof]
        current_user.score = current_user.score + @challenge.points
        current_user.save!
        @checkAchievement =   SubscribedAchievement.find_by_user_id_and_achievement_id(current_user.id,@challenge.achievement_id)
    
        if @checkAchievement
          @checkAchievement.level = @checkAchievement.level + 1
          @checkAchievement.save
        else
          #tODO:  Put in Max Sort Order, for when users can sort their achievements
          if @challenge.achievement_id
            SubscribedAchievement.create(:user_id=>current_user.id, :achievement_id=>@challenge.achievement_id, :level=>1, :sort_order=>0)
          end
        end
      end
    end
    
  end


  def update
    
    @subscribed = SubscribedChallenge.find(params[:id])
    @subscribed.update_attributes(params[:subscribed_challenge])
    
    if current_user.id == @subscribed.user_id
    
       if params[:video]
          @subscribed.panda_video_id = params[:video][:panda_video_id]
        end
        if params[:challenge]
          @subscribed.update_attributes(params[:challenge])
        end
        @subscribed.save!
    end
    

    if params[:subscribed_challenge] and params[:subscribed_challenge][:date_completed_on]
      #called via ajax upate to refresh time
      render :partial=>"subscribed_challenges/return_date"
    else
      redirect_to(:back)
    end
    
  end
  
  
  def add_note 
    
    @subscribed_challenge= SubscribedChallenge.find_by_challenge_id_and_user_id(params[:challenge_id],current_user.id)
    
    if @subscribed_challenge
      @subscribed_challenge.note = params[:note]
      @subscribed_challenge.save
    end
    
    @note =  params[:note]
    @challenge = Challenge.find(params[:challenge_id])
    render :partial=>"challenges/add_note"

  end
  



  def StompCookie_Write
    if cookies[:stomped]
      if cookies[:stomped].blank?
        cookies[:stomped] = params[:challenge_id]
      else
        cookies[:stomped] = cookies[:stomped] << ",#{params[:challenge_id]}"
      end
    else
      cookies[:stomped] = params[:challenge_id]
    end
  end
  
  def StompCookie_Read
    @challenges =  cookies[:stomped].split(",") 
  end
  
  def StompCookie_Delete
    if  cookies[:stomped]
      @challenges =  cookies[:stomped].split(",")
      @challenges_modify = "0"
      for var in @challenges
        if var != params[:challenge_id]
  		    @challenges_modify = "#{@challenges_modify},#{var}"
  		  end
  	  end
  	  cookies[:stomped] = @challenges_modify
  	end
  end
  
  
  
  
  def ChallengeCookie_Write
    if cookies[:challenges]
      if cookies[:challenges].blank?
        cookies[:challenges] = params[:challenge_id]
      else
        cookies[:challenges] = cookies[:challenges] << ",#{params[:challenge_id]}"
      end
    else
      cookies[:challenges] = params[:challenge_id]
    end
  end
  
  def ChallengeCookie_Read
    @challenges =  cookies[:challenges].split(",") 
  end
  
  def ChallengeCookie_Delete
    if  cookies[:challenges]
      @challenges =  cookies[:challenges].split(",")
      @challenges_modify = "0"
      for var in @challenges
        if var != params[:challenge_id]
  		    @challenges_modify = "#{@challenges_modify},#{var}"
  		  end
  	  end
  	  cookies[:challenges] = @challenges_modify
  	end
  end
  
  
  
  def panda_callback
    @encoding_data =  Panda.get("/videos/#{params[:panda_video_id]}/encodings.json")
    @thumbnail_id = @encoding_data[0]['id']
    image_url = "http://s3.amazonaws.com/trek.io.video/#{@thumbnail_id}_1.jpg"
    

       
    @subscribed_challenge = SubscribedChallenge.find_by_panda_video_id(params[:panda_video_id])
    if @subscribed_challenge
       #io = open(URI.parse(image_url))
       #io.write "#{Rails.root}/public/test.png"
  
       tempfile = Tempfile.new("test")
       tempfile.write open(image_url).read
       @subscribed_challenge.proof  = tempfile
       
      @subscribed_challenge.save!
    end
  end
  
  
  def regenerate_embed
  
  
      s3_bucket_url = "http://s3.amazonaws.com/trek.io.video/"

      #@video_data = Panda.get("/videos/#{params[:panda_id]}.json")

      # Find the url of the video from the first profile
      @encoding_data = Panda.get("/videos/#{params[:panda_id]}/encodings.json")
      
      @url1 = @encoding_data[0]
      @url2 = @encoding_data[1]

      @video_url1 = s3_bucket_url + @url1['id'] + @url1['extname']
      @video_url2 = s3_bucket_url + @url2['id'] + @url2['extname']

      @screenshot_url = s3_bucket_url + @url1['id'] + "_1.jpg"
      
   render :layout => false
   
  end
  
  
  

end
