# == Schema Information
#
# Table name: ttrip_requests
#
#  id           :uuid             not null, primary key
#  phone_number :string
#  location     :string
#  tuktuk_id    :uuid
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sms_id       :uuid
#

# Status can be:
# failed    - if the driver took too long to respond 
# waiting   - if the message was not sent too long ago and a response is being awaited 
# success   - if the driver accepted the trip request
# cancelled -  if the driver did not accept the trip or the customer cancelled this trip

class TtripRequest < ApplicationRecord
	belongs_to :tuktuk
	belongs_to :sms
	has_one    :sms_ttrip_request
	has_one    :ttrip
	after_commit :send_sms_ttrip_request, on: :create

	include Triprequest
	# a ttrip is created  if a ttrip_request is successful
	# 
	# send message to driver asking if they can take this job
	# send message to customer saying we are getting you a tuktuk
	

	# this method is triggered from the sms controller when a trip request is successfully made
	# this method is called after the trip request is saved in the dB
	def send_sms_ttrip_request 
		# make a new sms to request the trip
 		phone_number = self.phone_number
 		sent_sms = "Kuna Kazi, hapo #{self.location} Uko free? Jibu na Ndio au la"#check sms controller for the real sms
 		status  = "waiting" # this will change as soon as the driver responds appropriately
 		ttrip_request_id = self.id
 		received_sms = ""#get response from driver through sms controller

 		params = []
 		params << phone_number << sent_sms << ttrip_request_id << received_sms << status

 		save_params = ttrip_request_params params

 		sms = SmsTtripRequest.new(save_params)
 		sms.save
 		
 		logger.debug "Created New SMS Tuktuk Trip Request"		
	end

	def start_trip
		# make a new trip
		trip_params_array  = []
		ttrip_request_id  = self.id
		status 			  = "started"
		trip_params_array << ttrip_request_id << status

		save_params = ttrip_params trip_params_array
		new_trip = Ttrip.new(save_params)
		new_trip.save

		# Make Driver availabilty to false.
		# The driver after completing the trip can then text back to update their availability status or 
		# TODO
		# automatically update this after 30mins
		self.tuktuk.update_attributes(status: "false")
		
		return new_trip
	end

	def cancel_trip

		logger.debug "Cancelling A trip"	
		cancelled_trip = self

		# change status
		cancelled_trip.update_attributes(status: "cancelled")
		# changed sent sms status
		cancelled_trip.sms_ttrip_request.update_attributes(status: "cancelled")
		# make driver available
		cancelled_trip.tuktuk.update_attributes(status: "true")

		logger.debug "Customer has Cancelled A tuktuk Trip request"
		return cancelled_trip
	end

	


######################
#
# TODO
# change waiting to failed in an hour(done). create cron job
# when this changes to failed, a new trip request should be made.
# 
# 



protected

	def ttrip_request_params data
		name = ["phone_number", "sent_sms", "ttrip_request_id", "received_sms", "status"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
		
	end



	def ttrip_params data
		name = ["ttrip_request_id", "status"]
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
end
