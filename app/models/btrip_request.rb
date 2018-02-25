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

	# a ttrip is created  if a ttrip_request is successfu
end
