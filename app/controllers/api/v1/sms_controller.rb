class Api::V1::SmsController < Api::V1::BaseController
  

  def create
  	@sms = Sms.new(sms_params)
		# process and save the SMS
		
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
				
				render json: { sms: [ {
					success: true, message: "#{result_array[4]} number plate: #{result_array[2]} yaja hapo #{result_array[3]}. Utapigiwa simu na dereva pia. Subiri kidogo...",
								 phone_number: "#{result_array[1]}"
				 	},

					{
					 	success: true, message: "Customer Number: #{result_array[1]}. Mpigie simu, amesama yuko #{result_array[3]}. Kazi kwako!",
					 				 phone_number: "#{@sms.phone_number}"
					}

					]}, status: :ok

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
					render json: { sms: [ 
					{
					 	success: true, message: "#{driver_name}, Kuna Kazi, hapo #{trip.get_current_location} Uko free? Jibu na Ndio au la ",
					 				 phone_number: "#{@driver_phone_number}"
					}

					]}, status: :ok
				else

					# trip request was not successful. maybe all drivers were busy
					# maybe suggest another transport mode
					transport_mode = trip.get_transport_mode
					location = trip.get_current_location
					customer_number = trip.get_customer_number

					render json: { sms: [success: false, message: "Asante. Umeagiza #{transport_mode} ikuchukue #{location}. #{transport_mode} zote ziko busy. Jaribu baadaye...kidogo",
					 phone_number: "#{customer_number}"]}, status: :ok

				end

			else
				# array size is 2
				# there was an error. 
				# send the driver that error message
				unkown_driiver = @sms.phone_number
				render json: { sms: [success: false, message: "#{result_array[1]}",
					 phone_number: "#{unkown_driiver}"]}, status: :ok
				
			end

		else
			# do customer stuff
			sms = @sms.process_customer_sms

			if sms.class != Array
				# there's no error
				# make_trip request
				trip = sms.make_trip_request

				driver_phone_number = trip.get_driver_phone_number
				customer_number = @sms.phone_number
				transport_mode = trip.get_transport_mode
				location = trip.get_current_location
				driver_name = trip.get_driver_first_name

				if trip
					# trip request was successful
					# send message to both driver and customer

					render json: { sms: [ {
					success: true, message: "Asante. Umeagiza #{transport_mode} ikuchukue #{location}. Subiri kidogo...",
								 phone_number: "#{customer_number}"
				 	},

					{
					 	success: true, message: "#{driver_name}, Kuna Kazi, hapo #{trip.location} Uko free? Jibu na Ndio au la ",
					 				 phone_number: "#{driver_phone_number}"
					}

					]}, status: :ok

				else
					# trip request was not successful. maybe all drivers were busy
					# maybe suggest another transport mode
					render json: { sms: [success: false, message: "Asante. Umeagiza #{transport_mode} ikuchukue #{location}. #{transport_mode} zote ziko busy. Jaribu baadaye...kidog",
					 phone_number: "#{customer_number}"]}, status: :ok
					
				end
			else
				# there's an error with the sms
				render json: { sms: [success: false,
				message: "Ujumbe haujakamilika. Ungependa kuchukuliwa wapi? Wataka Tukutuku au bajaji? Tafadhali tueleze pale ulipo na kama wataka tukutuku au bajaji. Kwa Mafano kama ni Rich Land tuma:::Bajaji Rich Land au tukutuku Rich Land. Jaribu tena.",
				phone_number: "#{@sms.phone_number}"]}, status: :ok
				
			end
		end		
  end



  protected

  def sms_params
	  params.permit(:phone_number,:message)
  end
end
