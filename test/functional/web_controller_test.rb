require 'test_helper'

class WebControllerTest < ActionController::TestCase
  test "should get spotlight" do
    get :spotlight
    assert_response :success
  end

  test "should get challenges" do
    get :challenges
    assert_response :success
  end

  test "should get leaders" do
    get :leaders
    assert_response :success
  end

  test "should get my_challenges" do
    get :my_challenges
    assert_response :success
  end

  test "should get inbox" do
    get :inbox
    assert_response :success
  end

  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get jobs" do
    get :jobs
    assert_response :success
  end

  test "should get tos" do
    get :tos
    assert_response :success
  end

  test "should get privacy" do
    get :privacy
    assert_response :success
  end

end
