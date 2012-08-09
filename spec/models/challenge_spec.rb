require 'spec_helper'

describe Challenge do
  it { should belong_to(:user) }
  it { should belong_to(:achievement) }
  it { should have_many(:subscribed_challenges) }

  # it { should have_attachment(:photo) }

  before(:each) do
    @challenge = Factory(:challenge)
  end

  it 'should return published challenges' do
    unpublished = Factory(:challenge, :published => false)
    published = Factory(:challenge, :published => true)

    Challenge.published.should include(published)
    Challenge.published.should_not include(unpublished)
  end

  it 'should strip leading whitespace from challenge details' do
    @challenge.title = "\nawesome challenge  \n  "
    @challenge.details = "\n\n challenge  details\n  "
    @challenge.location = "\nBoston MA\n\n    "
    @challenge.save && @challenge.reload
    @challenge.title.should == "awesome challenge"
    @challenge.details.should == "challenge  details"
    @challenge.location.should == "Boston MA"
  end
end
