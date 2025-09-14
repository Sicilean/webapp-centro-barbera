require 'test_helper'

class FattureControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fatture)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fattura" do
    assert_difference('Fattura.count') do
      post :create, :fattura => { }
    end

    assert_redirected_to fattura_path(assigns(:fattura))
  end

  test "should show fattura" do
    get :show, :id => fatture(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => fatture(:one).to_param
    assert_response :success
  end

  test "should update fattura" do
    put :update, :id => fatture(:one).to_param, :fattura => { }
    assert_redirected_to fattura_path(assigns(:fattura))
  end

  test "should destroy fattura" do
    assert_difference('Fattura.count', -1) do
      delete :destroy, :id => fatture(:one).to_param
    end

    assert_redirected_to fatture_path
  end
end
