class ApplicationController < ActionController::Base
 layout :layout_by_resource
  before_action :authenticate_admin!

  layout 'admin_lte_2'

  protect_from_forgery with: :exception



  private

	def layout_by_resource
	  byebug
		if devise_controller? && action_name == "new" #&& action_name == "edit"
			"admin_lte_2_sign_up"
		else
			"admin_lte_2"
		end
	   end

	#****User sign_in / sign_out page redirects****************#
  def after_sign_in_path_for(resource)

	if current_admin.is_admin?
	  session["user_return_to"] || "/" #user_index_path
	else
	  "/"
	end
  end

	def after_sign_out_path_for(resource_or_scope)
	#byebug
	end
   
	  
end
