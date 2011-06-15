module MessagesHelper
  def message_avatar(message)
    if message.user.nil? || message.user.avatar_file_name.blank?
      "/images/no_avatar.png"
    else
      "http://assets.stomp.io/avatars/#{message.user.id}/thumb_50_#{message.user.avatar_file_name}"
    end
  end

  def message_image_tag(message, options = {})
    image_tag(message_avatar(message), options)
  end
end
