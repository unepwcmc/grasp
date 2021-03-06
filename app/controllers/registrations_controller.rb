class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new
    disable_registration
  end

  protected
    def after_update_path_for(_resource)
      reports_path
    end

  private
    def disable_registration
      flash[:info] = "Registration is currently disabled, please contact UNEP-WCMC to create a user account"
      redirect_to landing_page_path
    end

    def update_resource(resource, params)
      if params[:current_password]
        resource.update_with_password(params)
      else
        resource.update(params)
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [
        :first_name,
        :last_name,
        :mobile_number,
        :second_email,
        :skype_username,
        :address_1,
        :address_2,
        :city,
        :post_code,
        :country
      ])
    end
end
