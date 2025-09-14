require 'test_helper'

class VariabiliControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variabili)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variabile" do
    assert_difference('Variabile.count') do
      post :create, :variabile => { }
    end

    assert_redirected_to variabile_path(assigns(:variabile))
  end

  test "should show variabile" do
    get :show, :id => variabili(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => variabili(:one).to_param
    assert_response :success
  end

  test "should update variabile" do
    put :update, :id => variabili(:one).to_param, :variabile => { }
    assert_redirected_to variabile_path(assigns(:variabile))
  end

  test "should destroy variabile" do
    assert_difference('Variabile.count', -1) do
      delete :destroy, :id => variabili(:one).to_param
    end

    assert_redirected_to variabili_path
  end
end
