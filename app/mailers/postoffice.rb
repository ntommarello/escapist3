class Postoffice < ActionMailer::Base
  default :from => "Escapist <noreply@escapist.me>"
  default_url_options[:host] = "escapist.me"
    
  def newmember(user, group)
    @user = user
    @group = group
    mail(:to      => "\"#{user.first_name} #{user.last_name}\" <#{user.email}>" ,
         :from => "\"Nick @ Escapist\" <nick@tommarello.com>" ,
         :subject => "Confirm your #{APP_NAME} account")
  end
   
   
  def cc_message(from_first, from_last, from_id, to_email, message, autotoken,reciever)
    @first_name = from_first    
    @last_name = from_last   
    @message = message 
    @autotoken = autotoken 
    @message_id = from_id
     
    mail(:to      => "\"#{reciever.first_name} #{reciever.last_name}\" <#{to_email}>" ,
         :subject => "#{from_first} #{from_last} sent you a message on #{APP_NAME}!")
         
  end
  
  
  def notify_signup(user,plan,organizer)
    @plan = plan
    @user = user
    @organizer = organizer
  
    mail(:to      => "\"#{organizer.first_name} #{organizer.last_name}\" <#{organizer.email}>" ,
         :subject => "#{user.first_name} #{user.last_name} signed up for #{plan.title}")
  end
  
  
  
  
  def cc_comment(organizer, comment, group, plan, from_first, from_last, from_id, to_email, message, autotoken, challenge_title,url,type)
    @comment = comment
    @group = group
    @plan = plan
    @first_name = from_first    
    @last_name = from_last   
    @message = message 
    @autotoken = autotoken 
    @message_id = from_id
    @title = challenge_title
    @challenge_url = url
    @type = type
     
    mail(:to      => "\"#{organizer.first_name} #{organizer.last_name}\" <#{organizer.email}>" ,
         :subject => "#{from_first} #{from_last} #{type} #{challenge_title}")
  end
  
  
  def cc_like(from_first, from_last, from_id, to_email, message, autotoken, challenge_title,url)
    @first_name = from_first    
    @last_name = from_last   
    @message = message 
    @autotoken = autotoken 
    @message_id = from_id
    @plan = challenge_title
    @challenge_url = url
     
    mail(:to      => to_email,
         :subject => "#{from_first} #{from_last} is interested in #{challenge_title}")
  end
  
  
  def invite(to_email, from_first_name, from_last_name, to_name, username)
   @to_name = to_name
   @username = username
   @from_name = "#{from_first_name} #{from_last_name}" 
    
   mail(:to      => to_email,
       :subject => "#{from_first_name} #{from_last_name} invited you to join #{APP_NAME}!")
         
  end
  
  
  def confirmation(user,plan, subscribed)
    
    
      @user = user
      @plan = plan
      @subscribed = subscribed
      
      if plan.start_time  
        @date = plan.start_time.strftime('%A, %B %e at %I:%M %p')
      end
      

       @purchased = TicketPurchase.find(:all, :conditions=>"subscribed_plan_id=#{@subscribed.id}", :include=>:ticket)
       email = render_to_string(:template => "tickets/show", :layout => false)
       email = PDFKit.new(email)  
       email = email.to_pdf 
      

      attachments["tickets.pdf"] = email

      mail(:to      => "\"#{user.first_name} #{user.last_name}\" <#{user.email}>" ,
        :subject => "Escapist Ticket & Receipt: #{plan.title}")
  end
  
  
end
