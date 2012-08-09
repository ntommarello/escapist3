class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
  
  scope :unread, :conditions => { :unread_receiver => true, :deleted_receiver => false }
  scope :messages_from, lambda { |user| { :conditions => { :user_id => user.id }} }
  scope :messages_to_or_from, lambda { |user| { :conditions => ["user_id = ? OR receiver_id = ?", user.id, user.id] }}

  validates_presence_of :user, :receiver, :message
  validate :validate_receiver_privacy

  def replied?
    Message.first(
      :conditions => ["user_id = ? AND receiver_id = ? AND created_at >= ?", 
        receiver_id, user_id, created_at
    ])
  end

  private

  def validate_receiver_privacy
    if receiver && user
      if !receiver.privacy_allow_messages || receiver.has_blocked?(user)
        errors.add(:base, 'Recipient does not allow private messages')
      end
    end
  end
end
