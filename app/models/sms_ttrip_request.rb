# == Schema Information
#
# Table name: sms_ttrip_requests
#
#  id               :uuid             not null, primary key
#  phone_number     :string
#  sent_sms         :string
#  received_sms     :string
#  status           :string
#  ttrip_request_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# status can be
# waiting   - the sms was not sent long ago, a response is being waited for
# falied    - The driver took too long to respond
# Cancelled - the driver did not accept the trip request or Customer cancelled there request
# success  - the driver accepted the trip request
# 
# phone_number is the customer's number

class SmsTtripRequest < ApplicationRecord
	belongs_to :ttrip_request
	after_commit :update_ttrip_request, on: :update

	# send message to driver asking if they can take this job
	# send message to customer saying we are getting you a tuktuk
	# if driver says yes, then upddate trip request to successful
	# then send sms to customer with tuk tuk No. plate
	# send sms to Driver with customer phone number and location
	# start an new trip
	# 
	
	# this method is called automatically when the a driver responds to a trip request sms
	# the response is saved and the status is updated accordingly
	# after the status is updated this method is called to update the 
	# ttrip_request status that initiated this sms with the appropriate status as 
	# explained above
	
	def get_current_location
		location = self.ttrip_request.get_current_location
		return location
	end

	def update_ttrip_request
		ttrip_request = self.ttrip_request
		status  	  = self.status
		ttrip_request.update_attributes(status: "#{status}")
		logger.debug "UPDATING Ttrip Request. Driver's response:: #{status}"
	end

	def start_trip
		trip = self.ttrip_request.start_trip

		if trip
			return trip
		else
			logger.debug "Error creating a new trip"
			return false
		end
	end
end
