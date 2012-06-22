require 'test_helper'

class ReportControllerTest < ActionController::TestCase
  test "should get all" do
    get :all
    assert_response :success
  end

  test "should get carpool" do
    get :carpool
    assert_response :success
  end

  test "should get non-participants" do
    get :non-participants
    assert_response :success
  end

end
