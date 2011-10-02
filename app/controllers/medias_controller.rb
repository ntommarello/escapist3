class MediasController < ApplicationController
  
  
  
  def create
    
    if current_user
      @media = Media.new(params[:media])
      @media.plan_id = params[:plan_id]
      @media.media_type = 0
      @media.save!
    end
    
    redirect_to "/escapes/#{params[:plan_id]}"
    
  end



  def destroy
    
    if current_user 
      @media = Media.find(params[:id])
      @media.destroy
    end
  end

  def update
  end

end
