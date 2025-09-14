require 'test_helper'

class AutoProvaRapportoItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auto_prova_rapporto_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auto_prova_rapporto_item" do
    assert_difference('AutoProvaRapportoItem.count') do
      post :create, :auto_prova_rapporto_item => { }
    end

    assert_redirected_to auto_prova_rapporto_item_path(assigns(:auto_prova_rapporto_item))
  end

  test "should show auto_prova_rapporto_item" do
    get :show, :id => auto_prova_rapporto_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => auto_prova_rapporto_items(:one).to_param
    assert_response :success
  end

  test "should update auto_prova_rapporto_item" do
    put :update, :id => auto_prova_rapporto_items(:one).to_param, :auto_prova_rapporto_item => { }
    assert_redirected_to auto_prova_rapporto_item_path(assigns(:auto_prova_rapporto_item))
  end

  test "should destroy auto_prova_rapporto_item" do
    assert_difference('AutoProvaRapportoItem.count', -1) do
      delete :destroy, :id => auto_prova_rapporto_items(:one).to_param
    end

    assert_redirected_to auto_prova_rapporto_items_path
  end
end
