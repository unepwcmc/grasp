require 'test_helper'

class AgenciesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:admin)
    sign_in @user
    @agency = FactoryGirl.build(:agency)
    @saved_agency = FactoryGirl.create(:agency)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agencies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agency" do
    assert_difference('Agency.count') do
      post :create, agency: {
        email:      @agency.email,
        name:       @agency.name,
        url:        @agency.url,
        address_1:  @agency.address_1,
        address_2:  @agency.address_2,
        city:       @agency.city,
        post_code:  @agency.post_code,
        country:    @agency.country
      }
    end

    assert_redirected_to agency_path(assigns(:agency))
  end

  test "should show agency" do
    get :show, id: @saved_agency
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @saved_agency
    assert_response :success
  end

  test "should update agency" do
    patch :update, id: @saved_agency, agency: {
      email:      @agency.email,
      name:       @agency.name,
      url:        @agency.url,
      address_1:  @agency.address_1,
      address_2:  @agency.address_2,
      city:       @agency.city,
      post_code:  @agency.post_code,
      country:    @agency.country
    }
    assert_redirected_to agency_path(assigns(:agency))
  end

  test "should destroy agency" do
    assert_difference('Agency.count', -1) do
      delete :destroy, id: @saved_agency
    end

    assert_redirected_to agencies_path
  end
end
