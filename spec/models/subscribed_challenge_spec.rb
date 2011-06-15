require 'spec_helper'

describe SubscribedChallenge do
  it { should belong_to(:user) }
  it { should belong_to(:challenge) }

  # it { should have_attachment(:proof) }

  it 'returns completed challenges' do
    complete = Factory(:subscribed_challenge, :completed => true)
    incomplete = Factory(:subscribed_challenge, :completed => false)

    SubscribedChallenge.completed.should include(complete)
    SubscribedChallenge.completed.should_not include(incomplete)
  end
end
