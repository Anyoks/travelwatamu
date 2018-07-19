# == Schema Information
#
# Table name: btrip_requests
#
#  id           :uuid             not null, primary key
#  phone_number :string
#  location     :string
#  bajaj_id     :uuid
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

#
# Status can be:
# failed    - if the driver took too long to respond 
# waiting   - if the message was not sent too long ago and a response is being awaited
# success   - if the driver accepted the trip request
# cancelled -  if the driver did not accept the trip 

class BtripRequest < ApplicationRecord
	belongs_to :bajaj
	belongs_to :sms
	has_one    :sms_btrip_request
	has_one    :btrip
	after_commit :send_sms_btrip_request, on: :create
	# a ttrip is created  if a ttrip_request is successful
	# 
	# after trip request is made, a new sms btrip request is made.
	# this one is sent to the driver and will wait for the response from the driver for atleast 1 min
	# when the driver responds, then the status of this trip request will change from waiting to success
	# if the driver accepted etc as explained above.
	
	include Triprequest

	# this method is triggered from the sms controller when a trip request is successfully made
	# this method is called after the trip request is saved in the dB
	def send_sms_btrip_request 
		# make a new sms to request the trip
 		phone_number = self.phone_number
 		sent_sms = "Kuna Kazi, hapo #{self.location} Uko free? Jibu na Ndio au la"#check sms controller for the real sms
 		status  = "waiting" # this will change as soon as the driver responds appropriately
 		btrip_request_id = self.id
 		received_sms = "" #this will be updated when the driver responds

 		params = []
 		params << phone_number << sent_sms << btrip_request_id << received_sms << status

 		save_params = btrip_request_params params

 		sms = SmsBtripRequest.new(save_params)
 		sms.save	
 		logger.debug "Created New SMS Tuktuk Trip Request"	
	end

	def start_trip
		# make a new trip
		trip_params_array  = []
		btrip_request_id  = self.id
		status 			  = "started"
		trip_params_array << btrip_request_id << status

		save_params = btrip_params trip_params_array
		new_trip = Btrip.new(save_params)
		new_trip.save

		# Make Driver availabilty to false.
		# The driver after completing the trip can then text back to update their availability status or 
		# TODO
		# automatically update this after 30mins
		self.bajaj.update_attributes(status: "false")

		return new_trip
	end

	def cancel_trip

		logger.debug "Cancelling A trip"	
		cancelled_trip = self

		# change status
		cancelled_trip.update_attributes(status: "cancelled")
		# changed sent sms status
		cancelled_trip.sms_btrip_request.update_attributes(status: "cancelled")
		# make driver available
		cancelled_trip.bajaj.update_attributes(status: "true")

		logger.debug "Customer has Cancelled A bajaj Trip request"
		return cancelled_trip
	end
	
	protected



	def btrip_request_params data
		name = ["phone_number", "sent_sms", "btrip_request_id", "received_sms", "status"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
		
	end

	def btrip_params data
		name = ["btrip_request_id", "status"]
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
	
end
