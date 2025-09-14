require 'test_helper'

class ProvaTipologiaItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prova_tipologia_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prova_tipologia_item" do
    assert_difference('ProvaTipologiaItem.count') do
      post :create, :prova_tipologia_item => { }
    end

    assert_redirected_to prova_tipologia_item_path(assigns(:prova_tipologia_item))
  end

  test "should show prova_tipologia_item" do
    get :show, :id => prova_tipologia_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prova_tipologia_items(:one).to_param
    assert_response :success
  end

  test "should update prova_tipologia_item" do
    put :update, :id => prova_tipologia_items(:one).to_param, :prova_tipologia_item => { }
    assert_redirected_to prova_tipologia_item_path(assigns(:prova_tipologia_item))
  end

  test "should destroy prova_tipologia_item" do
    assert_difference('ProvaTipologiaItem.count', -1) do
      delete :destroy, :id => prova_tipologia_items(:one).to_param
    end

    assert_redirected_to prova_tipologia_items_path
  end
end
