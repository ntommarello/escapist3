require 'spec_helper'

describe User do
  it { should have_many :subscribed_challenges }
  it { should have_many :subscribed_achievements }
  it { should have_many(:authentications) }
    
  it { should have_many(:achievements).through(:subscribed_achievements) }
  it { should have_many(:challenges).through(:subscribed_challenges) }

  it { should have_many :received_messages }
  it { should have_many :sent_messages }
  it { should have_many :blocks }
  it { should have_many :challenges_authored }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }

  it { should allow_value('bruce@waynetech.com').for(:email) }
  it { should_not allow_value('not-an-email').for(:email) }

  # it { should have_attached_file :avatar }

  before(:each) do
    @user = Factory(:user, :first_name => 'Peter', :last_name => 'Parker')
  end

  it 'has a full name' do
    @user.full_name.should == 'Peter Parker'
  end

  it 'should capitalize names when saving' do
    @user.first_name = 'pete'
    @user.last_name = 'parker'
    @user.save && @user.reload

    @user.first_name.should == 'Pete'
    @user.last_name.should == 'Parker'
  end

  it 'should strip whitespace from bio text' do
    @user.about_me = "\n\n      I'm pretty  great!  \n"
    @user.save && @user.reload
    @user.about_me.should == "I'm pretty  great!"
  end

  it 'should have some default bio text' do
    @user.about_me.should match(/I'm new/)
  end

  describe 'slugs' do
    it 'should auto-create a unique username (avoids collisions)' do
      @user = Factory.build(:user, :first_name => 'Peter', :last_name => 'Parker')
      @user.save

      @user.username.should == 'peter-parker-1'
    end

    it 'should be updated when the record is saved' do
      @user.first_name = 'Ben'
      @user.save && @user.reload

      @user.username.should == 'ben-parker'
    end
  end

  describe '#bucket_count' do
    it 'reflects the number of challenges that are TBD' do
      Factory(:subscribed_challenge, :user => @user, :completed => 0)
      @user.reload.bucket_count.should == 1
    end

    it 'does not include completed challenges' do
      Factory(:subscribed_challenge, :user => @user, :completed => true)
      @user.reload.bucket_count.should == 0
    end
  end

  describe '#unread_messages' do
    it 'is not empty' do
      message = Factory(:unread_message, :receiver => @user)
      @user.unread_messages.should include(message)
    end

    it 'is empty' do
      message = Factory(:message, :receiver => @user)
      @user.unread_messages.should_not include(message)
    end
  end

  describe '#current_inbox' do 
    it 'shows the most recent message from the sender' do
      sender = Factory(:user)
      message1 = Factory(:message, :user => sender, :receiver => @user, :created_at => Time.now - 1.hour)
      message2 = Factory(:message, :user => sender, :receiver => @user)

      @user.current_inbox.length.should == 2 # including initial signup message
      @user.current_inbox.last.message.should == message2.message
    end

    it 'order messages by recency' do
      message1 = Factory(:message, :receiver => @user, :created_at => Time.now - 6.minutes)
      message2 = Factory(:message, :receiver => @user, :created_at => Time.now - 2.minutes)
      message3 = Factory(:message, :receiver => @user, :created_at => Time.now - 4.minutes)

      @user.current_inbox.length.should == 4 # including initial signup message
      @user.current_inbox.second.message.should == message2.message
    end

    it 'prioritizes unread messages' do
      message1 = Factory(:message, :receiver => @user, :created_at => Time.now - 6.minutes)
      message2 = Factory(:unread_message, :receiver => @user, :created_at => Time.now - 8.minutes)
      message3 = Factory(:message, :receiver => @user, :created_at => Time.now - 4.minutes)

      @user.current_inbox.length.should == 4 # including initial signup message
      @user.current_inbox.second.message.should == message2.message
    end
  end

  it 'has blocked another user' do
    block = Factory(:block, :user => @user)
    @user.has_blocked?(block.receiver).should be_true
  end

  it 'does not allow messages from a specific user' do
    other_user = Factory(:user)
    @user.allow_messages_from?(other_user).should be_true

    @user.update_attribute(:privacy_allow_messages, false)
    @user.allow_messages_from?(other_user).should be_false

    @user.update_attribute(:privacy_allow_messages, true)
    block = Factory(:block, :user => @user, :receiver => other_user)
    @user.allow_messages_from?(other_user).should be_false
  end

  it 'has completed a challenge' do
    challenge = Factory(:challenge)
    Factory(:subscribed_challenge, :challenge => challenge, :user => @user, :completed => true)
    @user.has_completed?(challenge).should be_true
  end
end
