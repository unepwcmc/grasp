class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    reports_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to :back, alert: exception.message }
    end
  end

  protected
    def configure_permitted_parameters
      registration_keys = [:first_name, :last_name, :email, :password, :password_confirmation, :role_id]
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_keys)
    end
end
