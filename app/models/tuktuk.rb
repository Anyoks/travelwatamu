# == Schema Information
#
# Table name: tuktuks
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


# status:
# true means the tuktuk is available
# false means it is not available. Maybe they are busy now.
# default is false ------>maybe I should change this.
class Tuktuk < ApplicationRecord
	has_many :ttrip_requests
	has_many :sms_ttrip_requests,  through: :trip_requests
	has_many :ttrips,  through: :ttrip_requests

	scope :available, -> { where(status: true)}

	include Driver

	def available?

		if self.status == true
			return true
		else
			return false
		end
		
	end
	

	# make method to select a tuktuk for this based on the following params
	# 	- available
	# 	- han
	# 	- it has been X mins since the last trip (fairness, not busy)
	# 	- has less 5 trips today
	# 	- Responds to trip request smses (which ever the response)
	# 	- has X number of completed trips (Trust worthy)
	# 	- has less than X failed sms_trip_requests (responds to smses)
		
	

	def score
		# Every driver should have a score, calculated  dynamicaly based on activities
		# can be used to pick driver for trip...
			
	end
	
protected
	
	
	
end
