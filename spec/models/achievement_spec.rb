require 'spec_helper'

describe Achievement do
  it { should have_many(:challenges) }
  it { should have_many(:subscribed_achievements) }
  it { should have_many(:users).through(:subscribed_achievements) }
  it { should belong_to(:category) }

  # it { should have_attachment(:photo) }

  before(:each) do
    @achievement = Factory(:achievement, :name => 'Boat Racing')
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it 'should have a slug' do
    @achievement.slug.should == 'boat-racing'
  end
end
