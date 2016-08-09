require 'test_helper'

class ValidationsControllerTest < ActionController::TestCase
  setup do
    @validation = validations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:validations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create validation" do
    assert_difference('Validation.count') do
      post :create, validation: {  }
    end

    assert_redirected_to validation_path(assigns(:validation))
  end

  test "should show validation" do
    get :show, id: @validation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @validation
    assert_response :success
  end

  test "should update validation" do
    patch :update, id: @validation, validation: {  }
    assert_redirected_to validation_path(assigns(:validation))
  end

  test "should destroy validation" do
    assert_difference('Validation.count', -1) do
      delete :destroy, id: @validation
    end

    assert_redirected_to validations_path
  end
end
