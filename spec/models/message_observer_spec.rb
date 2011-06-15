require 'spec_helper'

describe MessageObserver do
  before(:each) do
    Factory(:achievement, :name => 'Early Adopter')
  end

  describe 'after create' do
    before(:each) do
      Postoffice.stubs(:cc_message).returns(@email = mock('Email'))
    end

    it 'creates an email' do
      # 3 emails get cc'd: 1 for each user creation (2) + the new message
      @email.expects(:deliver).times(3)

      receiver = Factory(:user)
      Factory(:message, :receiver => receiver, :message => 'fubar')
    end

    it 'does not send an email if privacy options are enabled' do
      # 2 emails get cc'd: 1 for each user creation (2)
      @email.expects(:deliver).times(2)

      receiver = Factory(:user)
      receiver.update_attribute(:privacy_cc_email, false)
      Factory(:message, :receiver => receiver, :message => 'fubar')
    end
  end
end
