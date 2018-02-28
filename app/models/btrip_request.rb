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
	has_one    :sms_btrip_request
	has_one    :btrip
	after_save :sms_ttrip_request
	# a ttrip is created  if a ttrip_request is successful
	# 
	# after trip request is made, a new sms btrip request is made.
	# this one is sent to the driver and will wait for the response from the driver for atleast 1 min
	# when the driver responds, then the status of this trip request will change from waiting to success
	# if the driver accepted etc as explained above.
	

	# this method is triggered from the sms controller when a trip request is successfully made
	# this method is called after the trip request is saved in the dB
	def sms_ttrip_request 
		# make a new sms to request the trip
 		phone_number = self.phone_number
 		sent_sms = "Kuna Kazi, hapo #{self.location} Uko free? Jibu na Ndio au la"#check sms controller for the real sms
 		status  = "waiting" # this will change as soon as the driver responds appropriately
 		ttrip_request_id = self.id
 		received_sms = ""#get response from driver through sms controller

 		params = []
 		params << phone_number << sent_sms << ttrip_request_id << received_sms << status

 		save_params = btrip_params params

 		sms = SmsBtripRequest.new(save_params)
 		sms.save		
	end

	def btrip_params data
		name = ["phone_number", "sent_sms", "btrip_request_id", "received_sms", "status"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
		
	end
	
end
