require 'test_helper'

class FavcomsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favcoms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favcom" do
    assert_difference('Favcom.count') do
      post :create, :favcom => { }
    end

    assert_redirected_to favcom_path(assigns(:favcom))
  end

  test "should show favcom" do
    get :show, :id => favcoms(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => favcoms(:one).to_param
    assert_response :success
  end

  test "should update favcom" do
    put :update, :id => favcoms(:one).to_param, :favcom => { }
    assert_redirected_to favcom_path(assigns(:favcom))
  end

  test "should destroy favcom" do
    assert_difference('Favcom.count', -1) do
      delete :destroy, :id => favcoms(:one).to_param
    end

    assert_redirected_to favcoms_path
  end
end
