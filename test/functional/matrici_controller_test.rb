require 'test_helper'

class MatriciControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:matrici)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create matrice" do
    assert_difference('Matrice.count') do
      post :create, :matrice => { }
    end

    assert_redirected_to matrice_path(assigns(:matrice))
  end

  test "should show matrice" do
    get :show, :id => matrici(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => matrici(:one).to_param
    assert_response :success
  end

  test "should update matrice" do
    put :update, :id => matrici(:one).to_param, :matrice => { }
    assert_redirected_to matrice_path(assigns(:matrice))
  end

  test "should destroy matrice" do
    assert_difference('Matrice.count', -1) do
      delete :destroy, :id => matrici(:one).to_param
    end

    assert_redirected_to matrici_path
  end
end
