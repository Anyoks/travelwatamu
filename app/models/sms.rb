# == Schema Information
#
# Table name: sms
#
#  id               :uuid             not null, primary key
#  message          :string
#  transport_mode   :string
#  phone_number     :string
#  current_location :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Sms < ApplicationRecord


	# sample message from customer
	# tuktuk watamu                     bajaji watamu
	# watamu tuktuk						watamu bajaji
	# mwisho wa lami tuk tuk            bajaj gede
	# 
	

	def process_customer_sms
		text_message = self.message
		phone_number = self.phone_number

		# if the message contains tuk or baj it should be a customer. 	
		# Must be a customer!
		# Get the trasport mode 
	
		transport_mode = get_transport_mode
		current_location = get_current_location

		# if the returned result is an array, there's an error
			if transport_mode.class != Array

				# Prepare to save the message
				params_array = []
				# this order is important
				params_array << self.message << transport_mode << phone_number << current_location

				save_params = sms_params params_array

				sms = Sms.new(save_params)
				sms.save
				return sms

			else
				logger.debug "Could not identify tranport mode in the text message: #{self.message}"
				return false, "There's no tranport mode in the text message."
			end		
	end

	def process_driver_sms
		# if the message contains ndio or la or busy or free it's definitely a driver replying the first text
		# if it's a driver then he probably is reply trip request sms with a yes or no
		# *******future implement he probably is telling the system that he is free or busy
		text_message = self.message
		phone_number = self.phone_number

		# tuktuk or bajaj?
		driver = which_driver 

		if driver.class.name == "Tuktuk"
			# check if he is just updating his status to free or busy or accepting a trip
			# the key is in the sms if it contains niko busy or niko free
			# 
			# look for the sms trip request he is replying to 
			# improvement would be to check the time as well because it could be a very old sms.
			# or i can make a cron job to cacell all trips that take more thatn x mins to receice
			# a response
			request_sms = driver.sms_ttrip_request.where(status: "waiting").first

			# if this is nil then there was no trip request made for him
			if request_sms.present?
				# check the response first
				if self.message.downcase == "yes" || self.message.downcase == "ndio"
					
					success = request_sms.update_attributes(status: "success", received_sms: "#{self.message}")

					if success 
						# go to sms_ttrip_request and add an after update 
						
						# send message to customer with driver N0. plate
						# send messge to driver with customer Phone Number
						return true, "success"
					else
						return false, "error updating the status"
					end
				elsif self.message.downcase == "no" || self.message.downcase == "la"
					
					cancel = request_sms.upddate_attributes(status: "cancelled")
					if cancel
						# initiate a new trip request with another driver
						return true, "cancelled"
					else
						return false, "error cancelling "
					end
				end
			else
				# if there's no sms_ttrip_request then there was no trip initiated
				logger.debug " No trip found for this driver"
				return false, "no trip request" 
			end 

		elsif driver.class.name == "Bajaj"
			# check trip request by phone number
			request_sms = driver.sms_btrip_request.where(status: "waiting").first
				byebug
			# if this is nil then there was no trip request made for him
			if request_sms.present?
				# check the response first
				if self.message.downcase == "yes" || self.message.downcase == "ndio"
					
					success = request_sms.update_attributes(status: "success", received_sms: "#{self.message}")

					if success 
						# go to sms_ttrip_request and add an after update 
						
						# send message to customer with driver N0. plate
						# send messge to driver with customer Phone Number
						return true, "success"
					else
						return false, "error updating the status"
					end
				elsif self.message.downcase == "no" || self.message.downcase == "la"
					
					cancel = request_sms.upddate_attributes(status: "cancelled")
					if cancel
						# initiate a new trip request with another driver
						return true, "cancelled"
					else
						return false, "error cancelling "
					end
				end
			else
				# if there's no sms_ttrip_request then there was no trip initiated
				logger.debug " No trip found for this driver"
				return false, "no trip request" 
			end 
		else
			logger.debug "Error Finding the driver"
			return false
		end
		
	end

	# returns true or false
	# true -- driver
	# false -- customer 
	def check_if_driver
		text_message = self.message
		phone_number = self.phone_number

		# remove all spaces and new lines so that its one word.
		tmp_text = text_message.upcase.downcase!.gsub(/[[:space:]]/, '')

		if tmp_text == "ndio" || tmp_text == "yes"
			logger.debug "This is a driver"

			return true
			# check trip request by phone number
		elsif tmp_text == "la" || tmp_text == "no"
			logger.debug "This is a driver"
			return true
			# check trip request
		else
			logger.debug "This is a customer"
			return false
		end			
	end

	def which_driver
		phone_number =  self.phone_number

		tuktuk_driver = Tuktuk.where(phone_number: "#{phone_number}").first

		bajaji_driver = Bajaj.where(phone_number: "#{phone_number}").first

		if tuktuk_driver.present?

			logger.debug "Found driver #{tuktuk_driver.first_name}"
			return tuktuk_driver

		elsif bajaji_driver.present?

			logger.debug "Found driver #{bajaji_driver.first_name}"
			return bajaji_driver

		else
			logger.debug "Could not find that driver"
			return false
		end
	end

	def get_transport_mode
		text_message = self.message
		phone_number = self.phone_number
		text_message.upcase.downcase!

		if text_message.include?("tuk")
			# tuktuk trip request
			# 
			# split the message in to words
			words = text_message.scan (/\w+/)

			
			# transport_mode = words[words.index{|s| s.include?("tuk")}]
			transport_mode = "tukutuku" #to standardize database data
			return transport_mode

		elsif text_message.include?("baj")
			# bajaj trip requrest
			# 
			# 
			words = text_message.scan (/\w+/)

			# transport_mode = words[words.index{|s| s.include?("baj")}]
			transport_mode = "bajaji" #to standardize database data
			return transport_mode
				
		else
			logger.debug "Transport mode extraction failed "
			
			return false, "The message Does not contian a trasport mode.Message ====> #{self.message}"
		end
	end

	def get_current_location
		text_message = self.message
		phone_number = self.phone_number
		text_message.downcase!

		# split the message in to words
		words = text_message.scan (/\w+/)

		# get current location for 
		if text_message.include?("tuk")
			location_array  = words - [words[words.index.each{|s| s.include?("tuk")}]]

			current_location = location_array.join(" ")
			return current_location
		elsif text_message.include?("baj")
			location_array = words - [words[words.index.each{|s| s.include?("baj")}]]
			
			current_location = location_array.join(" ")
			return current_location	
		else
			location_array  = words
			current_location = location_array.join(" ")

			logger.debug  " The message does not contian transport mode. Assuming the whole message is the current location."
			return current_location
		end

	end

	def make_trip_request
		# if transport mode is tuktuk
		if self.get_transport_mode == "tukutuku"
			request_trip = self.make_tuk_tuk_trip_request
			return request_trip

		elsif self.get_transport_mode == "bajaji"
			
		# if transport mode is bajaj
			request_trip = self.make_bajaji_trip_request
			return request_trip
		else
			logger.debug "Could not get trasport Mode"
			return false
		end
	end

	def make_tuk_tuk_trip_request
		phone_number = self.phone_number
		current_location = self.get_current_location
		status = "waiting"

		# get the very first tuktuk that is free.
		# In future we need a better way of identifying a tuktuk this method may be baised.
		# 
		# *****what if there's no free driver?
		tuktuk = Tuktuk.where(status: true).first

		col_name = ["phone_number", "location", "tuktuk_id", "status"] 

		params = []
		params << phone_number << current_location << tuktuk.id << status

		save_params =  trip_req_params(params, col_name) 

		trip = TtripRequest.new(save_params)
		trip.save
		logger.debug "Made a Tuktuk Trip Request For customer"
		return trip
	end

	def make_bajaji_trip_request
		phone_number = self.phone_number
		current_location = self.get_current_location
		status = "waiting"

		# get the very first tuktuk that is free.
		# In future we need a better way of identifying a tuktuk this method may be baised.
		# 
		# 
		# # *****what if there's no free driver?
		bajaji = Bajaj.where(status: true).first

		col_name = ["phone_number", "location", "bajaj_id", "status"] 

		params = []
		params << phone_number << current_location << bajaji.id << status

		save_params =  trip_req_params(params, col_name) 

		trip = BtripRequest.new(save_params)
		trip.save
		logger.debug "Made a Bajaj Trip Request For customer"
		return trip	
	end



protected
	
	def trip_req_params data, col_name
		coloumns = col_name
		hash = Hash[*coloumns.zip(data).flatten]
		return hash
	end
	# FOrm the sms parameters
	def sms_params data
		name = ["message", "transport_mode", "phone_number", "current_location"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
end
