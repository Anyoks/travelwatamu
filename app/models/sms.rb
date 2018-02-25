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
	def process_text
		text_message = self.message
		phone_number = self.phone_number


		# check if the text message include tuk or baj 
		if text_message.include?("tuk")
			# tuktuk trip request
			# 
			
			# split the message in to words
			words = text_message.scan (/\w+/)

			# return the word on the index that includes tuk. NOw we have the tranport mode
			transport_mode = words[words.index{|s| s.include?("tuk")}]

			# current_location - will be very difficult to determine if the user sends a long tex.
			# shortcut is sending this message straight to the driver so they can figure it out till
			# we find another way
			current_location = ""

			params_array = []
			# this order is important
			params_array << text_message << transport_mode << phone_number << current_location

			save_params = sms_params params_array

			@sms = Sms.new(save_params)
			@sms.save
			return @sms
		elsif text_message.include?("baj")
			# bajaj trip requrest
			# 
			words = text_message.scan (/\w+/)

			# return the word on the index that includes tuk. NOw we have the tranport mode
			transport_mode = words[words.index{|s| s.include?("baj")}]

			# current_location - will be very difficult to determine if the user sends a long tex.
			# shortcut is sending this message straight to the driver so they can figure it out till
			# we find another way
			current_location = ""

			params_array = []
			# this order is important
			params_array << text_message << transport_mode << phone_number << current_location

			save_params = sms_params params_array

			@sms = Sms.new(save_params)
			@sms.save
			return @sms
		else
			"Error with the message format, try with if you are in watamu
			tuktuk watamu or bajaji watamu"
			return false, "Error with the message format. If you are in watamu try
			tuktuk watamu or bajaji watamu"
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
