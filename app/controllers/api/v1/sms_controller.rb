class Api::V1::SmsController < Api::V1::BaseController
  

  def create
  	@sms = Sms.new(sms_params)
		# process and save the SMS
		# 
		
		@processed_text = @sms.process_text
		# byebug

		if @processed_text.class != Array 
			# attempt making a trip request from the message that has been successully processed
			# This will return a Bajaj or a Tuktuk trip request depending on what the user requsted
			@trip_request = @processed_text.make_trip_request

			#send amessage to both the customer and the free tukTuk/driver about the trip
			if @trip_request
				
				
				render json: { sms: [ {
					success: true, message: "Asante. Umeagiza #{@processed_text.transport_mode}
											 ikuchukue #{@processed_text.current_location}. Subiri kidogo...",
								 phone_number: "#{@sms.phone_number}"
				 },

				 {
				 	success: true, message: "Kuna Kazi, hapo #{@trip_request.location} Uko free? Jibu na Ndio au la ",
				 				 phone_number: "#{@trip_request.tuktuk.phone_number}"
				 }

				 ]}, status: :ok
				 
			else
				render json: { sms: [success: false, message: "Asante. Umeagiza #{@processed_text.transport_mode}
				 ikuchukue #{@processed_text.current_location}. Tukutuku zote ziko busy. Jaribu baadaye...kidog",
				 phone_number: "#{@sms.phone_number}"]}, status: :ok
			end

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
