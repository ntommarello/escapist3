require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = Factory(:user)
  end

  describe '#show' do
    it 'locates the user record by username' do
      sign_in(Factory(:user))

      get :show, :id => @user.username
      assigns(:user).should == @user
      assigns(:editable).should be_false

      response.should render_template('show')
    end

    it 'allows editing if this is my profile' do
      sign_in(@user)

      get :show, :id => @user.username
      assigns(:editable).should be_true
    end

    it 'lists challenges the user has authored' do
      challenge1 = Factory(:challenge, :user => @user)
      challenge2 = Factory(:challenge)
      Factory(:subscribed_challenge, :challenge => challenge1, :user => @user, :completed => true)
      get :show, :id => @user.username
      assigns(:challenges).should include(challenge1)
      assigns(:challenges).should_not include(challenge2)
    end
  end

  describe '#register' do
    it 'displays the registration page' do
      get :register
      response.should render_template('register')
    end
  end

  describe '#create' do
    it 'creates a new user and fill in session details' do
      lambda {
        post :create, { :user => Factory.attributes_for(:user) }, { :location_city => 'Portland ME', :lat => 43.65, :lng => 70.32 }
      }.should change(User, :count)

      User.last.location_city.should == 'Portland ME'
      User.last.hometown.should == 'Portland ME'
      User.last.lat.should == 43.65
      User.last.lng.should == 70.32
    end

    it 'adds challenges from bucket list to a newly created user' do
      challenge = Factory(:challenge)
      request.cookies[:challenges] = challenge.id

      lambda {
        post :create, :user => Factory.attributes_for(:user)
      }.should change(SubscribedChallenge, :count)

      User.last.challenges.should == [challenge]
    end

    it "adds created challenges to a newly created user" do
      challenge = Factory(:challenge)
      request.cookies[:challenges_created] = challenge.id

      post :create, :user => Factory.attributes_for(:user)
      User.last.challenges_authored.should == [challenge]
    end

    it 'redirects when creation is successful' do
      post :create, :user => Factory.attributes_for(:user)
      flash[:notice].should_not be_nil

      response.should be_redirect
      response.should redirect_to(user_path(User.last))
    end

    it 'redirects when creation fails' do
      post :create

      flash[:error].should_not be_nil
      response.should render_template('register')
    end
  end
end
