class ApplicationController < ActionController::Base
 layout :layout_by_resource
  before_action :authenticate_admin!

  # layout 'admin_lte_2'

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?



protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
	#devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
	devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password]) 
  end

  private

	def layout_by_resource
	  # byebug
		if devise_controller? && action_name == "new" || action_name == "create"#&& action_name == "edit"
			"admin_lte_2_sign_up"
		else
			"admin_lte_2"
		end
	end

	#****User sign_in / sign_out page redirects****************#
  def after_sign_in_path_for(resource)

	if current_admin.is_admin?
	  session["user_return_to"] || "/bajajs" #user_index_path
	else
	  "/bajajs"
	end
  end

	def after_sign_out_path_for(resource_or_scope)
	#byebug
	new_admin_session_path
	end
   
	  
end
