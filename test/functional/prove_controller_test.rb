require 'test_helper'

class ProveControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prove)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prova" do
    assert_difference('Prova.count') do
      post :create, :prova => { }
    end

    assert_redirected_to prova_path(assigns(:prova))
  end

  test "should show prova" do
    get :show, :id => prove(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prove(:one).to_param
    assert_response :success
  end

  test "should update prova" do
    put :update, :id => prove(:one).to_param, :prova => { }
    assert_redirected_to prova_path(assigns(:prova))
  end

  test "should destroy prova" do
    assert_difference('Prova.count', -1) do
      delete :destroy, :id => prove(:one).to_param
    end

    assert_redirected_to prove_path
  end
end
