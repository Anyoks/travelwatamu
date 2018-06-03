# == Schema Information
#
# Table name: bajajs
#
#  id           :uuid             not null, primary key
#  first_name   :string
#  last_name    :string
#  number_plate :string
#  phone_number :string
#  stage        :string
#  status       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Bajaj < ApplicationRecord
	has_many :btrip_requests
	has_many :sms_btrip_request,  through: :btrip_requests

	def available?

		if self.status == true
			return true
		else
			return false
		end
		
	end
end
