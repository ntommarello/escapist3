class Postoffice < ActionMailer::Base
  default :from => "#{APP_NAME} <noreply@#{APP_URL}>"
  default_url_options[:host] = "#{APP_URL}"
    
  def newmember(to_email, user_id)
    @user_id = user_id
    mail(:to      => to_email,
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
  
  
  
  def cc_comment(from_first, from_last, from_id, to_email, message, autotoken, challenge_title,url,type)
    @first_name = from_first    
    @last_name = from_last   
    @message = message 
    @autotoken = autotoken 
    @message_id = from_id
    @plan = challenge_title
    @challenge_url = url
    @type = type
     
    mail(:to      => to_email,
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
  
  
  
  
  
end
