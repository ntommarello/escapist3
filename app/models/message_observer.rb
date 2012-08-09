class MessageObserver < ActiveRecord::Observer
  def after_create(message)
    if message.receiver.privacy_allow_messages? && message.receiver.privacy_cc_email?
      Postoffice.cc_message(message.user.first_name, message.user.last_name, message.user.id, 
                            message.receiver.email, message.message, 
                            message.receiver.authentication_token,message.receiver).deliver
    end 
  end
end
