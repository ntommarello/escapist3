require 'spec_helper'

describe SubscribedAchievement do
  it { should belong_to(:user) }
  it { should belong_to(:achievement) }
end
