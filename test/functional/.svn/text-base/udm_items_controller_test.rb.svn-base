require 'test_helper'

class UdmItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:udm_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create udm_item" do
    assert_difference('UdmItem.count') do
      post :create, :udm_item => { }
    end

    assert_redirected_to udm_item_path(assigns(:udm_item))
  end

  test "should show udm_item" do
    get :show, :id => udm_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => udm_items(:one).to_param
    assert_response :success
  end

  test "should update udm_item" do
    put :update, :id => udm_items(:one).to_param, :udm_item => { }
    assert_redirected_to udm_item_path(assigns(:udm_item))
  end

  test "should destroy udm_item" do
    assert_difference('UdmItem.count', -1) do
      delete :destroy, :id => udm_items(:one).to_param
    end

    assert_redirected_to udm_items_path
  end
end
