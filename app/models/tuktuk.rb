class Tuktuk < ApplicationRecord
	has_many :ttrip_requests
	has_many :sms_ttrip_request,  through: :ttrip_requests
end
