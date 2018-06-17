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
	has_many :sms_ttrip_request,  through: :ttrip_requests
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

	# def self.available?

	# 	available_tuktuks = Tuktuk.where(status: true)
	# 	total = available_tuktuks.count

	# 	if total == 0
	# 		return total
	# 	else
	# 		return available_tuktuks
	# 	end
		
	# end

	def make_available
		self.update_attributes(status: true)
	end

	# make method to select a tuktuk for this based on the following params
	# 	- available
	# 	- han
	# 	- it has been X mins since the last trip (fairness, not busy)
	# 	- has less 5 trips today
	# 	- Responds to trip request smses (which ever the response)
	# 	- has X number of completed trips (Trust worthy)
	# 	- has less than X failed sms_ttrip_requests (responds to smses)
		
	

	def score
		# Every driver should have a score, calculated  dynamicaly based on activities
		# can be used to pick driver for trip...
			
	end

	# (positive response/total reequestst) * 100%
	def responsiveness
		last_3_days = self.ttrip_requests.where(created_at: 3.days.ago..Time.now)
		positive_response = last_3_days.where.not(status: 'failed').where.not(status: 'waiting')
		count = positive_response.count

		level = Tuktuk.responsivenes_level count, last_3_days.count

		score = Tuktuk.get_score level 
		return score
	end

	

	

	def self.responsive_drivers
		list_of_responsive_drivers = TtripRequest.responsive_drivers
		
		return list_of_responsive_drivers
	end

	 # redundant because this is the same as responsiveness
	def successful_trips
		success_trips = self.ttrip_requests.where(status: 'success')
	end

	def completed_trips
		trips = self.ttrips.where(status: 'started')
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	

	def self.no_trips_today
		self.left_outer_joins(:ttrips).where( ttrips: {created_at:Time.zone.now.beginning_of_day..Time.zone.now.end_of_day})
	end

	



	# #######################################################################
	# 														                #
	# CANCELLED/ SUCCESSFUL/ FAILED/ WAITING REQUESTS (today, week, month ) #
	# 														                #
	# #######################################################################
	# ths gets all requests, failed or successful
	def requests_today
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	def waiting_requests_today
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'waiting')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	# this method accepts true or false to return data or just count.
	def success_requests_today(args) 

		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
		total = requests.count
		
		if  :false
			if total == 0
				return total
			else
				return requests.count
			end
		elsif :true
			
			puts "this si it" #args[:data]
			return requests
		else
			if total == 0
				return total
			else
				return requests.count
			end
		end
		
		
	end

	def failed_requests_today
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'failed')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	# check number of completed requests today
	
	def completed_requests_today

		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def completed_requests_today

		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	# check number of failed requests today
	
	def failed_requests_today

		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'failed')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def failed_requests_today

		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'failed')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	# Check started Trips today
	# 
	def cancelled_requests_today

		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'cancelled')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def cancelled_requests_today

		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'cancelled')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	#****THIS WEEK******#
	
	# check Number of started requests this week
	def week_success_requests
		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "success")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def week_success_requests
		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "success")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end


	# check Numnber of failed requests this week
	def week_failed_requests
		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "failed")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def week_failed_requests
		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "failed")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end


	def week_cancelled_requests

		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now, status: 'cancelled')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def week_cancelled_requests

		
		requests = self.ttrip_requests.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now, status: 'cancelled')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end
	
	#********THIS MONTH************#
	#
	#
	def month_success_requests
		requests =  self.ttrip_requests.where(created_at: 1.month.ago..Time.zone.now, status: "success").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def month_success_requests
		requests =  self.ttrip_requests.where(created_at: 1.month.ago..Time.zone.now, status: "success").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def month_failed_requests
		requests = self.ttrip_requests.where(created_at: 1.month.ago..Time.zone.now, status: "failed").count
		total = requests.count
		if total == 0
			return total
		else
			return requests
		end
		
	end

	def month_failed_requests
		requests = self.ttrip_requests.where(created_at: 1.month.ago..Time.zone.now, status: "failed").count
		total = requests.count
		if total == 0
			return total
		else
			return requests
		end
		
	end

	def month_cancelled_requests
		requests = self.ttrip_requests.where(created_at: 1.month.ago..Time.zone.now, status: "cancelled").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	def month_cancelled_requests
		requests = self.ttrip_requests.where(created_at: 1.month.ago..Time.zone.now, status: "cancelled").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	######################


protected
	

	

	

	
end
