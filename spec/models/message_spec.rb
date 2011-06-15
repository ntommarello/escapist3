require 'spec_helper'

describe Message do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:receiver) }
  it { should validate_presence_of(:message) }

  describe 'validation' do
    before(:each) do
      @sender = Factory(:user)
      @recipient = Factory(:user)
    end

    it 'fails if recipient does not allow messages' do
      @recipient.update_attribute(:privacy_allow_messages, false)
      message = Factory.build(:unread_message, :user => @sender, :receiver => @recipient)
      message.should_not be_valid
      message.errors[:base].should include('Recipient does not allow private messages')
    end

    it 'fails if recipient has blocked the sender' do
      Factory(:block, :user => @recipient, :receiver => @sender)
      message = Factory.build(:unread_message, :user => @sender, :receiver => @recipient)
      message.should_not be_valid
      message.errors[:base].should include('Recipient does not allow private messages')
    end
  end

  describe 'is unread' do
    it 'only if user has not read it' do
      message = Factory(:unread_message)
      Message.unread.should include(message)
    end

    it 'only if user has not deleted it' do
      message = Factory(:unread_message, :deleted_receiver => true)
      Message.unread.should_not include(message)
    end
  end

  it 'is from a specific user' do
    message1 = Factory(:message)
    message2 = Factory(:message)
    Message.messages_from(message1.user).should include(message1)
  end

  it 'is to or from a specific user' do
    msg_from_user = Factory(:message)
    msg_to_user = Factory(:message, :user => msg_from_user.receiver, :receiver => msg_from_user.user)
    msg_other = Factory(:message)

    Message.messages_to_or_from(msg_to_user.user).should include(msg_to_user)
    Message.messages_to_or_from(msg_to_user.user).should include(msg_from_user)
    Message.messages_to_or_from(msg_to_user.user).should_not include(msg_other)
  end

  it 'has been replied to' do
    message = Factory(:message)
    message.should_not be_replied

    reply = Factory(:message, :user => message.receiver, :receiver => message.user)
    message.should be_replied
  end
end
