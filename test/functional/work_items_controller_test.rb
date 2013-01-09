require 'test_helper'

class WorkItemsControllerTest < ActionController::TestCase
  setup do
    @work_item = work_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_item" do
    assert_difference('WorkItem.count') do
      post :create, work_item: {  }
    end

    assert_redirected_to work_item_path(assigns(:work_item))
  end

  test "should show work_item" do
    get :show, id: @work_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work_item
    assert_response :success
  end

  test "should update work_item" do
    put :update, id: @work_item, work_item: {  }
    assert_redirected_to work_item_path(assigns(:work_item))
  end

  test "should destroy work_item" do
    assert_difference('WorkItem.count', -1) do
      delete :destroy, id: @work_item
    end

    assert_redirected_to work_items_path
  end
end
