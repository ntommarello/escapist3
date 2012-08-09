require 'spec_helper'

describe UserObserver do
  before(:each) do
    Factory(:achievement, :name => 'Early Adopter')
  end

  describe 'after create' do
    it 'grants the early adopter achievement' do
      lambda {
        Factory(:user)
      }.should change(SubscribedAchievement, :count)

      User.last.achievements.first.slug.should == 'early-adopter'
    end

    it 'sends the new member confirmation email' do
      Postoffice.expects(:newmember).with('clark@kent.net', anything).returns(email = mock('Email'))
      email.expects(:deliver)

      Factory(:user, :email => 'clark@kent.net')
    end

    it 'creates a welcome notification' do
      lambda {
        Factory(:user)
      }.should change(Message, :count)

      User.last.received_messages.first.message.should match(/Welcome to/)
    end
  end
end
