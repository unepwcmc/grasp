require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @admin = FactoryGirl.create(:admin)
    sign_in @admin

    @user = FactoryGirl.build(:provider)
    @saved_user = FactoryGirl.create(:validator)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
        first_name:             @user.first_name,
        last_name:              @user.last_name,
        email:                  @user.email,
        second_email:           @user.second_email,
        password:               @user.password,
        password_confirmation:  @user.password_confirmation,
        skype_username:         @user.skype_username,
        address_1:              @user.address_1,
        address_2:              @user.address_2,
        city:                   @user.city,
        post_code:              @user.post_code,
        country:                @user.country,
        role_id:                @user.role.id,
        agency_id:              @user.agency.id
      }
    end

    assert_redirected_to admin_user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @saved_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @saved_user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @saved_user, user: {
      first_name:             @user.first_name,
      last_name:              @user.last_name,
      email:                  @user.email,
      second_email:           @user.second_email,
      password:               @user.password,
      password_confirmation:  @user.password_confirmation,
      skype_username:         @user.skype_username,
      address_1:              @user.address_1,
      address_2:              @user.address_2,
      city:                   @user.city,
      post_code:              @user.post_code,
      country:                @user.country,
      role_id:                @user.role.id,
      agency_id:              @user.agency.id
    }


    assert_redirected_to admin_user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @saved_user
    end

    assert_redirected_to admin_users_path
  end
end
