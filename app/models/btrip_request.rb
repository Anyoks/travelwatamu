class BtripRequest < ApplicationRecord
	belongs_to :bajaj
	has_one    :sms_btrip_request
end
