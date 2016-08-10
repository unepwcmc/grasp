require 'test_helper'

class ValidationsControllerTest < ActionController::TestCase
  setup do
    @validator = FactoryGirl.create(:validator)
    sign_in @validator

    @validation       = FactoryGirl.build(:validation)
    @saved_validation = FactoryGirl.create(:validation)
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
      post :create, validation: {
        report_id: @validation.report.id,
        state: @validation.state,
        comments_for_provider: @validation.comments_for_provider,
        comments_for_admin: @validation.comments_for_admin
      }, report_id: @validation.report_id, accept: nil
    end

    assert_redirected_to validation_path(assigns(:validation))
  end

  test "should show validation" do
    get :show, id: @saved_validation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @saved_validation
    assert_response :success
  end

  test "should update validation" do
    patch :update, id: @saved_validation, validation: {
      report_id: @validation.report.id,
      state: @validation.state,
      comments_for_provider: @validation.comments_for_provider,
      comments_for_admin: @validation.comments_for_admin
    }
    assert_redirected_to validation_path(assigns(:validation))
  end

  test "should destroy validation" do
    assert_difference('Validation.count', -1) do
      delete :destroy, id: @saved_validation
    end

    assert_redirected_to validations_path
  end
end
