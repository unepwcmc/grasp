class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Authenticate user and load CanCanCan permissions
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /users
  def index
    @users = User.all
    @users = Sorters::Users.sort(@users, params[:sort], params[:dir])
    @users = @users.page(params[:page])
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    generated_password = Devise.friendly_token.first(8)

    @user = User.new(user_params)
    @user.password = generated_password
    @user.password_confirmation = generated_password

    if @user.save
      NotificationMailer.notify_user_of_account_creation(@user, generated_password).deliver_later
      redirect_to admin_user_path(@user), notice: t("admin.users.created")
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: t("admin.users.updated")
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: t("admin.users.destroyed")
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :first_name, :last_name,
        :email, :second_email,
        :role_id,
        :password, :password_confirmation,
        :agency_id,
        :skype_username,
        :address_1, :address_2,
        :city, :post_code, :country,
        :mobile_number,
        {expertise_ids: []}
      )
    end
end
