class AchievementsController < ApplicationController
  require 'titlecase'
  
  def index

    @achievements = Achievement.paginate(:all,  :per_page=>14, :page => params[:page] || 1, :order=>"created_at desc")
    
    render :layout=>false
  end
  
  
  def achievement_live_results
    @search_text = params[:search_text]
    @achievements = Achievement.search "#{@search_text}*",  :match_mode => :any, :limit=>14   
    
    render :partial=>"achievements/live_results"
  end
  
  
  
  
  def show
    @achievement = Achievement.find_by_slug!(params[:id])
    @editable = true if (current_user && current_user.mod_level == 5)

    # Geokit doesn't appear to work with named scope. Lame.
    @challenges = Challenge.paginate(:all, :page => params[:page] || 1,
                                     :conditions => ["published=? and achievement_id=?", true, @achievement.id], 
                                     :origin => [session[:lat],session[:lng]], :order=>"distance asc")

    @users = @achievement.users.active.sort_photos_first
    
    if  @achievement.category
      @related_achievements = Achievement.find(:all, :conditions=>["id != ? and category_id = ?",@achievement.id, @achievement.category.id])
      @related_challenges = Challenge.find(:all, :select=>"challenges.*", :joins=>:achievement, :conditions=>["published=? and challenges.id != ? and achievements.id != ? and achievements.category_id = ?",true,@achievement.id, @achievement.id, @achievement.category.id],:origin => [session[:lat],session[:lng]], :order=>"distance asc")
    else
    @related_achievements= ""
    @related_challenges = ""
    end
  end

  def create
    
    #only admins can create
    #if !current_user or current_user.mod_level != 5
    #  return
    #end
    
    params[:achievement][:name] = params[:achievement][:name].titlecase
    
    @ach = Achievement.find_by_name(params[:achievement][:name])
    @created = "0"
    unless @ach
      @created = "1"
      @ach = Achievement.new(params[:achievement])
      @ach.description = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
      @ach.group = APP_PEOPLE
      @ach.save
    end
    
    if params[:challenge_id]
      @challenge = Challenge.find(params[:challenge_id])
      @challenge.achievement_id = @ach.id
      @challenge.save!
    end
    
    render :layout=>false
    
  end
  
  def update
    
    #only admins can update
    #if !current_user or current_user.mod_level != 5
     # return
    #end
    
    @ach = Achievement.find(params[:id])
    @ach.update_attributes(params[:achievement])
    @ach.save
    
    redirect_to "#{request.env['HTTP_REFERER']}"
    
  end
  
  
  
  

end
