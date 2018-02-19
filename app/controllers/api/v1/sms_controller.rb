class Api::V1::SmsController < Api::V1::BaseController
  def create
  end

  protected

  def sms_params
	  params.permit(:phone_number,:message)
  end
end
