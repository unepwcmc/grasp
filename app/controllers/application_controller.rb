class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    super
    # Direct each user to their relevant home path on sign in
    #case resource.role.name
    #when "admin"      then root_path
    #when "validator"  then root_path
    #when "provider"   then root_path
    #else
      #root_path
    #end
  end

  protected
    def configure_permitted_parameters
      registration_keys = [:first_name, :last_name, :email, :password, :password_confirmation, :role_id]
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_keys)
    end
end
