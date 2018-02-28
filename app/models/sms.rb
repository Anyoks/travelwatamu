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
	

	def process_text
		text_message = self.message
		phone_number = self.phone_number


		# Get the trasport mode 
		# 
		transport_mode = get_transport_mode
		current_location = get_current_location

		# if the returned result is an array, there's an error
		if transport_mode.class != Array

			# Prepare to save the message
			params_array = []
			# this order is important
			params_array << self.message << transport_mode << phone_number << current_location

			save_params = 	 params_array

			sms = Sms.new(save_params)
			sms.save
			return sms

		else
			logger.debug "Could not identify tranport mode in the text message: #{self.message}"
			return false, "There's no tranport mode in the text message."
		end
		
	end

	def get_transport_mode
		text_message = self.message
		phone_number = self.phone_number
		text_message.downcase!

		if text_message.include?("tuk")
			# tuktuk trip request
			# 
			# split the message in to words
			words = text_message.scan (/\w+/)

			
			transport_mode = words[words.index{|s| s.include?("tuk")}]
			return transport_mode

		elsif text_message.include?("baj")
			# bajaj trip requrest
			# 
			# 
			words = text_message.scan (/\w+/)

			transport_mode = words[words.index{|s| s.include?("baj")}]
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



protected
	

	# FOrm the sms parameters
	def sms_params data
		name = ["message", "transport_mode", "phone_number", "current_location"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
end
