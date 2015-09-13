require 'test_helper'

class MoneyboxesControllerTest < ActionController::TestCase
  setup do
    @moneybox = moneyboxes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:moneyboxes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create moneybox" do
    assert_difference('Moneybox.count') do
      post :create, moneybox: { current: @moneybox.current, name: @moneybox.name, percentage: @moneybox.percentage, summary: @moneybox.summary }
    end

    assert_redirected_to moneybox_path(assigns(:moneybox))
  end

  test "should show moneybox" do
    get :show, id: @moneybox
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @moneybox
    assert_response :success
  end

  test "should update moneybox" do
    patch :update, id: @moneybox, moneybox: { current: @moneybox.current, name: @moneybox.name, percentage: @moneybox.percentage, summary: @moneybox.summary }
    assert_redirected_to moneybox_path(assigns(:moneybox))
  end

  test "should destroy moneybox" do
    assert_difference('Moneybox.count', -1) do
      delete :destroy, id: @moneybox
    end

    assert_redirected_to moneyboxes_path
  end
end
