class Api::V1::SmsController < Api::V1::BaseController
  before_action :ensure_message_param_exists
  before_action :ensure_phone_number_param_exists

  def create
  	@sms = Sms.new(sms_params)
		# process and save the SMS
		# byebug
		# check if driver or customer
		sender = @sms.check_if_driver

		if sender
			# do driver stuff
			result_array = @sms.process_driver_sms
			
			if result_array.size == 5
				# success message
				# send driver customer contacts
				# send customer driver plates
				# return true, customer_number, driver_plate, location, "tukutuku"
				
				return successful_trip_request_message result_array
				
			elsif result_array.size == 4

			 	return registered_driver_response result_array

			elsif result_array.size == 3
				# driver rejected the  job
				# make a new trip request 
				# send message only to driver
				# return true, sms, "cancelled"
				sms = result_array[1]
				trip = sms.make_trip_request

				# get phone number of the driver
				@driver_phone_number = trip.get_driver_phone_number
				driver_name = trip.get_driver_first_name

				if trip
					# send message to new driver
					return success_driver_trip_request trip
					# render json: { sms: [ 
					# {
					#  	success: true, message: "#{driver_name}, Kuna Kazi, hapo #{trip.get_current_location} Uko free? Jibu na Ndio au la ",
					#  				 phone_number: "#{@driver_phone_number}", rcv: "driver"
					# }

					# ]}, status: :ok
				else

					# trip request was not successful. maybe all drivers were busy
					# maybe suggest another transport mode
					return fail_driver_trip_request trip

				end

			else
				# array size is 2
				# there was an error. 
				# send the driver that error message
				return unknown_driver result_array
				# unkown_driiver = @sms.phone_number
				# render json: { sms: [success: false, message: "#{result_array[1]}",
				# 	 phone_number: "#{unkown_driiver}", rcv: "driver"]}, status: :ok
				
			end

		else
			# do customer stuff
			# check if customer is cancelling or requesting
			check_intention = @sms.is_this_a_cancel_trip_request

			if check_intention
				cancelled_trip = @sms.cancel_trip_request
				# cancel a trip
				
				if cancelled_trip.class != Array

					return cancelled_trip_sms_response cancelled_trip
					
				else
					return missing_trip_to_cancel 
						
				end

			else
				# Check if double_request
				double_req = @sms.check_if_double_request

				if double_req[0]
					# double request
					# do something about this
					# maybe save this in a double tripRequest
					return found_a_double_request double_req
					# transport_mode = double_req[1]
					# render json: { sms: [success: false, message: "Asante. Uliagizia #{transport_mode}, itatumwa sasa hivi, subiri kidogo \n Jibu na STOP kusitisha safari hii.",
					#  phone_number: "#{@sms.phone_number}", rcv: "customer"]}, status: :ok
				else
					# make a new trip
					sms = @sms.process_customer_sms

					if sms.class != Array
						# there's no error
						# make_trip request
						trip = sms.make_trip_request	
						# byebug
						if trip.class != Array
							# trip request was successful
							# send message to both driver and customer
							# 
							return complete_trip_request_message trip
					
						else
							
							return unsuccessful_trip_request trip
		
						end
					else
						# there's an error with the sms
						#  Tafadhali tueleze pale ulipo na kama wataka tukutuku au bajaji. Kwa Mafano kama ni Rich Land tuma:::Bajaji Rich Land au tukutuku Rich Land. Jaribu tena.
						return error_with_customer_request_sms
						
						
					end
					
				end
				
			end
		end		
  end

  def all
  	
  end



  protected

  def error_with_customer_request_sms
  	render json: { sms: [
  		{
	  		success: false,
		  	message: "Ujumbe haujakamilika. Ungependa kuchukuliwa wapi? Wataka Tukutuku au bajaji? Tafadhali tueleze pale ulipo na kama wataka tukutuku au bajaji. Kwa Mafano kama ni Rich Land tuma:::Bajaji Rich Land au tukutuku Rich Land. Jaribu tena.",
		  	phone_number: "#{@sms.phone_number}"
	 	}
	]}, status: :ok
  end

  def registered_driver_response result_array 
	render json: { sms: [
	 	success: true, message: "Usajili Umekamilika.\nNames: #{result_array[0]} #{result_array[1]}.\nNumber Plate: #{result_array[2]}.\nStage: #{result_array[3]}", phone_number:"#{@sms.phone_number}", rcv: "driver"

 	]}, status: :ok
  end

  def success_driver_trip_request trip
  	@driver_phone_number = trip.get_driver_phone_number
  	driver_name = trip.get_driver_first_name
  	location = trip.get_current_location
  	render json: { sms: [ 
	  	{
	  	 	success: true, message: "#{driver_name}, Kuna Kazi, hapo #{location} Uko free? Jibu na Ndio au la ",
	  	 				 phone_number: "#{@driver_phone_number}", rcv: "driver"
	  	}

  	]}, status: :ok
  end

  def fail_driver_trip_request trip
  	transport_mode = trip.get_transport_mode
  	location = trip.get_current_location
  	customer_number = trip.get_customer_number

  	render json: { sms: [
  		{
  			success: false, message: "Asante. Umeagiza #{transport_mode} ikuchukue #{location}. #{transport_mode} zote ziko busy. Jaribu baadaye...kidogo",
  			phone_number: "#{customer_number}", rcv: "customer"
  		}
  		
  	]}, status: :ok
  	
  end

  def unknown_driver result_array
  	unkown_driiver = @sms.phone_number
  	render json: { sms: [
  		{
	  		success: false, message: "#{result_array[1]}",
	  		phone_number: "#{unkown_driiver}", rcv: "driver"
  		}

	]}, status: :ok
  	
  end

  def successful_trip_request_message result_array
  	render json: { sms: [ 

  		{
  		success: true, message: "#{result_array[4]} number plate: #{result_array[2]} yaja hapo #{result_array[3]}. Utapigiwa simu na dereva pia. Subiri kidogo...",
  					 phone_number: "#{result_array[1]}", rcv: "customer"
  	 	},

  		{
  		 	success: true, message: "Customer Number: #{result_array[1]}. Mpigie simu, amesama yuko #{result_array[3]}. Kazi kwako!",
  		 				 phone_number: "#{@sms.phone_number}", rcv: "driver"
  		}

  	]}, status: :ok
  end

  def cancelled_trip_sms_response cancelled_trip
  		customer_no = @sms.phone_number
  		driver_no = cancelled_trip.get_driver_phone_number
  		transport_mode = cancelled_trip.get_transport_mode
  		location = cancelled_trip.get_current_location
  		driver_name = cancelled_trip.get_driver_first_name

  		render json: { sms: [ 
  			{
  				success: true, message: "Umecancel #{transport_mode} isije #{location}.  Asante kwa kutumia huduma hii.",
  					 phone_number: "#{customer_no}", rcv: "customer"
	  	 	},

	  		{
	  		 	success: true, message: "#{driver_name}, Customer #{customer_no} wa, hapo #{cancelled_trip.location} amekatiza safari hii. Usiende huko. ",
	  		 				 phone_number: "#{driver_no}", rcv: "driver"
	  		}

  		]}, status: :ok
  end

  def missing_trip_to_cancel
  		customer_no = @sms.phone_number
  		render json: { sms: [ 
  			{
	  			success: true, message: "Samahani, haujaagiza tukutuku/bajaji ije kukuchukua",
	  					 phone_number: "#{customer_no}", rcv: "customer"
  	 		}
  	 	]}, status: :ok
  end

  def found_a_double_request double_req
	transport_mode = double_req[1]
	render json: { sms: [
		{
			success: false, message: "Asante. Uliagizia #{transport_mode}, itatumwa sasa hivi, subiri kidogo \n Jibu na STOP kusitisha safari hii.",
			phone_number: "#{@sms.phone_number}", rcv: "customer"
		}

	]}, status: :ok
  	
  end

  def complete_trip_request_message trip
	driver_id = trip.get_driver_id
	driver_phone_number = trip.get_driver_phone_number
	customer_number = @sms.phone_number
	transport_mode = trip.get_transport_mode
	location = trip.get_current_location
	driver_name = trip.get_driver_first_name

	render json: { sms: [ 
		{
			success: true, message: "Asante. Umeagiza #{transport_mode} ikuchukue #{location}. Subiri kidogo... \n Tuma STOP kusimamisha safari hii",
			phone_number: "#{customer_number}", rcv: "customer"
	 	},

		{
		 	success: true, message: "#{driver_name}, Kuna Kazi, hapo #{trip.location} Uko free? Jibu na Ndio au la. uko na sekunde 60. ",
		 	phone_number: "#{driver_phone_number}", rcv: "driver"
		}

	]}, status: :ok

	# make the driver avalibale after 10 minutes
	DriverAvailableWorker.perform_in(10.minutes, driver_id, transport_mode)
  end

  def unsuccessful_trip_request trip
  	# trip request was not successful. maybe all drivers were busy
  	# TODO: maybe suggest another transport mode
  	# 
  	transport_mode = trip[2]
  	 	
  	# transport_mode = trip[2]
  	render json: { sms: [
  		{
  			success: false, message: "Asante. Umeagiza #{transport_mode} ikuchukue #{location}. #{transport_mode} zote ziko busy. Jaribu baadaye...kidogo",
  		  	 phone_number: "#{@sms.phone_number}", rcv: "customer"
  		}

  	]}, status: :ok
  end

  def ensure_message_param_exists
  	ensure_param_exists :message
  end

  def ensure_phone_number_param_exists
  	ensure_param_exists :phone_number
  end

  def ensure_param_exists(param)
    return unless params[param].blank?
    render json:{ success: false, error: "Missing #{param} parameter"}, status: :unprocessable_entity
  end

  def sms_params
	  params.permit(:phone_number,:message)
  end
end
