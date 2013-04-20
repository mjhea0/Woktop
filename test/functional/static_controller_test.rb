require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get policy" do
    get :policy
    assert_response :success
  end

  test "should get terms" do
    get :terms
    assert_response :success
  end

end
