class TtripRequest < ApplicationRecord
	belongs_to :tuktuk
	has_one    :sms_ttrip_request
end
