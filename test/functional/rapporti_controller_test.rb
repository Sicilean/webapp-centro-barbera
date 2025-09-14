require 'test_helper'

class RapportiControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rapporti)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rapporto" do
    assert_difference('Rapporto.count') do
      post :create, :rapporto => { }
    end

    assert_redirected_to rapporto_path(assigns(:rapporto))
  end

  test "should show rapporto" do
    get :show, :id => rapporti(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => rapporti(:one).to_param
    assert_response :success
  end

  test "should update rapporto" do
    put :update, :id => rapporti(:one).to_param, :rapporto => { }
    assert_redirected_to rapporto_path(assigns(:rapporto))
  end

  test "should destroy rapporto" do
    assert_difference('Rapporto.count', -1) do
      delete :destroy, :id => rapporti(:one).to_param
    end

    assert_redirected_to rapporti_path
  end
end
