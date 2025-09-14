require 'test_helper'

class TipologieControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipologie)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipologia" do
    assert_difference('Tipologia.count') do
      post :create, :tipologia => { }
    end

    assert_redirected_to tipologia_path(assigns(:tipologia))
  end

  test "should show tipologia" do
    get :show, :id => tipologie(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tipologie(:one).to_param
    assert_response :success
  end

  test "should update tipologia" do
    put :update, :id => tipologie(:one).to_param, :tipologia => { }
    assert_redirected_to tipologia_path(assigns(:tipologia))
  end

  test "should destroy tipologia" do
    assert_difference('Tipologia.count', -1) do
      delete :destroy, :id => tipologie(:one).to_param
    end

    assert_redirected_to tipologie_path
  end
end
