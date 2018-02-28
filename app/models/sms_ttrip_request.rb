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
# Cancelled - the driver did not accept the trip request
# success  - the driver accepted the trip request
# 
# phone_number is the customer's number

class SmsTtripRequest < ApplicationRecord
	belongs_to :ttrip_request

	# send message to driver asking if they can take this job
	# send message to customer saying we are getting you a tuktuk
	# if driver says yes, then upddate trip request to successful
	# then send sms to customer with tuk tuk No. plate
	# send sms to Driver with customer phone number and location
	# start an new tripm
	
end
