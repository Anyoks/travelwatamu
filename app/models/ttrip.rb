

# status
# started 	- driver found the customer and took them
# completed - driver responded after successful trip completion
# failed 	- driver accepted trip but passenger refused or driver didn't go and told the system
class Ttrip < ApplicationRecord
	belongs_to :ttrip_request
	has_many :tuktuks, through: :ttrip_requests


	def self.successful_trips
		trips = Ttrip.where(status: 'started')
	end
	# check current trip (status started) (tuk.currently?)
	# 
	# 
	# 
	# TODAY
	# Total Trips today
	def self.trips_today
		return Ttrip.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
	end

	def trips_today
		return self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
	end
	# 
	# check number of completed trips today
	def completed_trips_today

		trips = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'completed')
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	# check number of failed trips today
	def failed_trips_today

		
		trips = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'failed')
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	# Check started Trips today
	# 
	def started_trips_today

		
		trips = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'started')
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	#****THIS WEEK******#
	
	# check Number of started trips this week
	def week_started_trips
		
		trips = self.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "started")
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	# check Numnber of completed trips this week

	def week_completed_trips
		
		trips = self.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "completed")
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	# check Numnber of failed trips this week
	def week_failed_trips
		
		trips = self.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "failed")
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end
	
	#********THIS MONTH************#
	#
	#
	def month_complete_trips
		trips =  self.where(created_at: 1.month.ago..Time.zone.now, status: "completed").count
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	def month_failed_trips
		trips = self.where(created_at: 1.month.ago..Time.zone.now, status: "failed").count

		if total == 0
			return total
		else
			return trips
		end
		
	end
	# 
	# check Number of completed trips all time
	# 
	# 
	
	# 
	# 
	# Check Number of completed trips this month
	# 
	# 
	
	# 
	# 
	# check Number of failed trips all time
	# 
	# 
	
	# 
	# 
	# Check Number of  failed trips this month

	def tuktuk
		return self.ttrip_request.tuktuk
	end
end
