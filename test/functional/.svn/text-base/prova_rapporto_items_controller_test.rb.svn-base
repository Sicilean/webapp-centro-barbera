require 'test_helper'

class ProvaRapportoItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prova_rapporto_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prova_rapporto_item" do
    assert_difference('ProvaRapportoItem.count') do
      post :create, :prova_rapporto_item => { }
    end

    assert_redirected_to prova_rapporto_item_path(assigns(:prova_rapporto_item))
  end

  test "should show prova_rapporto_item" do
    get :show, :id => prova_rapporto_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prova_rapporto_items(:one).to_param
    assert_response :success
  end

  test "should update prova_rapporto_item" do
    put :update, :id => prova_rapporto_items(:one).to_param, :prova_rapporto_item => { }
    assert_redirected_to prova_rapporto_item_path(assigns(:prova_rapporto_item))
  end

  test "should destroy prova_rapporto_item" do
    assert_difference('ProvaRapportoItem.count', -1) do
      delete :destroy, :id => prova_rapporto_items(:one).to_param
    end

    assert_redirected_to prova_rapporto_items_path
  end
end
