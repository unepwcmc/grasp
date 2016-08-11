require 'test_helper'

class ValidationsControllerTest < ActionController::TestCase
  setup do
    @validator = FactoryGirl.create(:validator)
    sign_in @validator

    @validation       = FactoryGirl.build(:validation)
    @saved_validation = FactoryGirl.create(:validation)
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
      }, report_id: @validation.report_id, accept: "Accept"
    end

    assert_equal "Validated", Validation.last.report.state
    assert_redirected_to validation_path(assigns(:validation))
  end
end
