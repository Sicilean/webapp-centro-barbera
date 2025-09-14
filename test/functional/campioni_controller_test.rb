require 'test_helper'

class CampioniControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campioni)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campione" do
    assert_difference('Campione.count') do
      post :create, :campione => { }
    end

    assert_redirected_to campione_path(assigns(:campione))
  end

  test "should show campione" do
    get :show, :id => campioni(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => campioni(:one).to_param
    assert_response :success
  end

  test "should update campione" do
    put :update, :id => campioni(:one).to_param, :campione => { }
    assert_redirected_to campione_path(assigns(:campione))
  end

  test "should destroy campione" do
    assert_difference('Campione.count', -1) do
      delete :destroy, :id => campioni(:one).to_param
    end

    assert_redirected_to campioni_path
  end
end
