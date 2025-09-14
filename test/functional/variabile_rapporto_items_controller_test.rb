require 'test_helper'

class VariabileRapportoItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variabile_rapporto_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variabile_rapporto_item" do
    assert_difference('VariabileRapportoItem.count') do
      post :create, :variabile_rapporto_item => { }
    end

    assert_redirected_to variabile_rapporto_item_path(assigns(:variabile_rapporto_item))
  end

  test "should show variabile_rapporto_item" do
    get :show, :id => variabile_rapporto_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => variabile_rapporto_items(:one).to_param
    assert_response :success
  end

  test "should update variabile_rapporto_item" do
    put :update, :id => variabile_rapporto_items(:one).to_param, :variabile_rapporto_item => { }
    assert_redirected_to variabile_rapporto_item_path(assigns(:variabile_rapporto_item))
  end

  test "should destroy variabile_rapporto_item" do
    assert_difference('VariabileRapportoItem.count', -1) do
      delete :destroy, :id => variabile_rapporto_items(:one).to_param
    end

    assert_redirected_to variabile_rapporto_items_path
  end
end
