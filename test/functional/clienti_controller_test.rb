require 'test_helper'

class ClientiControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clienti)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cliente" do
    assert_difference('Cliente.count') do
      post :create, :cliente => { }
    end

    assert_redirected_to cliente_path(assigns(:cliente))
  end

  test "should show cliente" do
    get :show, :id => clienti(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => clienti(:one).to_param
    assert_response :success
  end

  test "should update cliente" do
    put :update, :id => clienti(:one).to_param, :cliente => { }
    assert_redirected_to cliente_path(assigns(:cliente))
  end

  test "should destroy cliente" do
    assert_difference('Cliente.count', -1) do
      delete :destroy, :id => clienti(:one).to_param
    end

    assert_redirected_to clienti_path
  end
end
