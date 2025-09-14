require 'test_helper'

class ProvaVariabileItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prova_variabile_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prova_variabile_item" do
    assert_difference('ProvaVariabileItem.count') do
      post :create, :prova_variabile_item => { }
    end

    assert_redirected_to prova_variabile_item_path(assigns(:prova_variabile_item))
  end

  test "should show prova_variabile_item" do
    get :show, :id => prova_variabile_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prova_variabile_items(:one).to_param
    assert_response :success
  end

  test "should update prova_variabile_item" do
    put :update, :id => prova_variabile_items(:one).to_param, :prova_variabile_item => { }
    assert_redirected_to prova_variabile_item_path(assigns(:prova_variabile_item))
  end

  test "should destroy prova_variabile_item" do
    assert_difference('ProvaVariabileItem.count', -1) do
      delete :destroy, :id => prova_variabile_items(:one).to_param
    end

    assert_redirected_to prova_variabile_items_path
  end
end
