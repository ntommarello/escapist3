class MessagesController < ApplicationController
  
  
  def sent
    
    if !current_user
      redirect_to root_path
      return
    end
    
    @message_list =  Message.messages_from(current_user).find(:all, :limit=>100, :order => 'created_at DESC', :include=>:receiver)
  end
  
  
  
  def inbox
    
    if !current_user
      redirect_to root_path
      return
    end
    
    
    @message_list = current_user.current_inbox
  end
  
  def show
    @receiver = User.find(params[:id])
    
    if @receiver
      @offset = params[:offset].to_i
    
      if !current_user or !@receiver
        redirect_to "/"
        return
      end

      Message.update_all("unread_receiver = 0", "user_id=#{@receiver.id} AND receiver_id=#{current_user.id}")
      @messages = Message.messages_to_or_from(current_user).messages_to_or_from(@receiver).all(
        :conditions => { :warned => false }, :limit => 30, :order => 'created_at DESC', :offset => @offset)
    end
    
    respond_to do |wants|
      wants.xml  { render :xml => @messages }
      wants.html { render }
    end
  end


  def create
    if params[:message] 
       params[:message] = CGI.unescape(params[:message])
    end
    
    #naughty users lose messaging privilages.
    if current_user.hidden_reputation > 50
      # NOTE: doesn't notify user if recipient delivery fails
      # (for example if they have PMs disabled)
      msg = current_user.sent_messages.create(:receiver_id => params[:receiver_id], :message => params[:message])
    end

    @receiver = User.find(params[:receiver_id]) 
    @offset = params[:offset].to_i
    @messages = Message.messages_to_or_from(current_user).messages_to_or_from(@receiver).all(
      :conditions => { :warned => false }, :limit => 30, :order => 'created_at DESC', :offset => @offset)

    render :partial => "messages/messagethread", :layout => false
  end


  def update
  end


  def destroy
      id = params[:id]
       Message.update_all("deleted_receiver = 1", "user_id=#{id} and receiver_id=#{current_user.id}")
   end


   def reply_message 
     @user = User.find_by_authentication_token(params[:user_credentials])
     sign_in @user
     redirect_to "/messages/#{params[:id]}"
   end
   
   
   def no_cc
     @user = User.find_by_authentication_token(params[:user_credentials])
     sign_in @user
        
        
    if params[:type] and params[:type] == "comment"   
      flash[:message] = "#{APP_NAME} will no longer email comment notifications."
      @user.messaging_bucket_comment = 0
    else 
      if params[:type] and params[:type] == "signup"
        flash[:message] = "#{APP_NAME} will no longer email signup notifications."
        @user.privacy_cc_signups = 0
      else
        flash[:message] = "#{APP_NAME} will no longer CC messages to your e-mail."
        @user.privacy_cc_email = 0
      end
    end
    
     @user.save!
     
     redirect_to '/settings'
   end
   
   

   def notifications
  
   end


end
