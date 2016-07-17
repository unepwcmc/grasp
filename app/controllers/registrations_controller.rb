class RegistrationsController < Devise::RegistrationsController
  def new
    disable_registration
  end

  private
    def disable_registration
      flash[:info] = "Registration is currently disabled, please contact UNEP-WCMC to create a user account"
      redirect_to root_path
    end
end
