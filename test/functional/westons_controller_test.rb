require 'test_helper'

class WestonsControllerTest < ActionController::TestCase
  setup do
    @weston = westons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:westons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weston" do
    assert_difference('Weston.count') do
      post :create, weston: {  }
    end

    assert_redirected_to weston_path(assigns(:weston))
  end

  test "should show weston" do
    get :show, id: @weston
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @weston
    assert_response :success
  end

  test "should update weston" do
    put :update, id: @weston, weston: {  }
    assert_redirected_to weston_path(assigns(:weston))
  end

  test "should destroy weston" do
    assert_difference('Weston.count', -1) do
      delete :destroy, id: @weston
    end

    assert_redirected_to westons_path
  end
end
