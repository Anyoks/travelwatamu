class Bajaj < ApplicationRecord
	has_many :btrip_requests
	has_many :sms_btrip_request,  through: :btrip_requests
end
