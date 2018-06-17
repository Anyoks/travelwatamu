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

##########################################
	def requests_today
		requests = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	# check number of completed requests today
	
	def self.completed_requests_today

		requests = SmsTtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def completed_requests_today

		requests = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	# check number of failed requests today
	
	def self.failed_requests_today

		requests = SmsTtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'failed')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def failed_requests_today

		requests = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'failed')
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

		
		requests = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'cancelled')
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
		
		requests = self.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "success")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end


	# check Numnber of failed requests this week
	def week_failed_requests
		
		requests = self.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "failed")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end


	def week_cancelled_requests

		
		requests = self.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now, status: 'cancelled')
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
		requests =  self.where(created_at: 1.month.ago..Time.zone.now, status: "success").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def month_failed_requests
		requests = self.where(created_at: 1.month.ago..Time.zone.now, status: "failed").count
		total = requests.count
		if total == 0
			return total
		else
			return requests
		end
		
	end

	def month_cancelled_requests
		requests = self.where(created_at: 1.month.ago..Time.zone.now, status: "cancelled").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end
	# 
	# check Number of completed requests all time
	# 
	# 
	
	# 
	# 
	# Check Number of completed requests this month
	# 
	# 
	
	# 
	# 
	# check Number of failed requests all time
	# 
	# 
	
	# 
	# 
	# Check Number of  failed requests this month
















	# Check current request (status waiting) sms_ttrip_request.currently?
	# 
	# 
	# check Number of successful requests today
	# 
	# 
	# Check Number of seccessful requests this week
	# 
	# 
	# Check Number of successful requests this month
	# 
	# 
	# check Number of cancelled requests today
	# 
	# 
	# Check Number of cancelled requests this week
	# 
	# 
	# Check Number of cancelled requests this month
	# 
	
	# check Number of failed requests today
	# 
	# 
	# Check Number of failed requests this week
	# 
	# 
	# Check Number of failed requests this month
end
