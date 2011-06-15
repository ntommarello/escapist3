require 'spec_helper'

describe AchievementsController do
  before(:each) do
    @achievement = Factory(:achievement)
  end

  describe '#show' do
    before(:each) do
      @challenge = Factory(:challenge)
      @user = Factory(:user)
    end

    it 'should display challenges and users associated with an achievement' do
      get :show, :id => @achievement.slug
      pending
    end
  end
end
