class Api::V1::BaseController < ActionController::API
	# before_action :authenticate_admin!
	respond_to :json
	
	rescue_from ActionController::ParameterMissing do
		api_error(status: 400, errors: 'Invalid parameters')
	end

	rescue_from ActiveRecord::RecordNotFound do
		api_error(status: 404, errors: 'Resource not found!')
	end

	# rescue_from UnauthenticatedError do
	# 	unauthenticated!
	# end

protected 

	def unauthenticated!
      unless Rails.env.production? || Rails.env.test?
        Rails.logger.warn { "Unauthenticated user not granted access" }
      end

      api_error(status: 401, errors: 'Not Authenticated')
    end


	def api_error(status: 500, errors: [])
      puts errors.full_messages if errors.respond_to?(:full_messages)

      render json: Api::V1::ErrorSerializer.new(status, errors).as_json,
        status: status
    end
end
