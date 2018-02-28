class Api::V1::SmsController < Api::V1::BaseController
  

  def create
  	@sms = Sms.new(sms_params)
		# process and save the SMS
		# 
		
		@processed_text = @sms.process_text
		# byebug

		if @processed_text.class != Array 
			# # attempt redeem, the result is an array with true/false + the error or success message
			# @redeemed_status = @processed_text.attempt_redeem

			# if @redeemed_status[0] == true 
				
				# render json: { success: true, message: "#{@redeemed_status[1]}", phone_number: "#{@sms.phone_number}" }, status: :ok
				render json: { sms: [success: true, message: "Asante. Umeagiza #{@processed_text.transport_mode}
				 ikuchukue #{@processed_text.current_location}. Subiri kidogo...",
				 phone_number: "#{@sms.phone_number}"]}, status: :ok
				

			# else
			# 	# render json: { success: false, error: "#{@redeemed_status[1]}",  phone_number: "#{@sms.phone_number}"}, status: :unprocessable_entity
			# 	render json: { sms: [success: false, message: "#{@redeemed_status[1]}", phone_number: "#{@sms.phone_number}"]}, status: :ok
			# end

		else
			
			# render json: { success: false, error: "#{@processed_text[1]}", phone_number: "#{@sms.phone_number}"}, status: :unprocessable_entity
			render json: { sms: [success: false,
				message: "Ujumbe haujakamilika. Ungependa kuchukuliwa wapi?
				Wataka Tukutuku au bajaji? 
				Tafadhali tueleze pale ulipo na kama wataka tukutuku au bajaji. Kwa Mafano kama ni Rich Land tuma:::  
				Bajaji Rich Land au tukutuku Rich Land. Jaribu tena.",
				phone_number: "#{@sms.phone_number}"]}, status: :ok
		end
		
  end



  protected

  def sms_params
	  params.permit(:phone_number,:message)
  end
end
