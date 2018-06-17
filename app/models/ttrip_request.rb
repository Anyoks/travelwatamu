# == Schema Information
#
# Table name: ttrip_requests
#
#  id           :uuid             not null, primary key
#  phone_number :string
#  location     :string
#  tuktuk_id    :uuid
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

class TtripRequest < ApplicationRecord
	belongs_to :tuktuk
	belongs_to :sms
	has_one    :sms_ttrip_request
	has_one    :ttrip
	after_commit :send_sms_ttrip_request, on: :create


	# a ttrip is created  if a ttrip_request is successful
	# 
	# send message to driver asking if they can take this job
	# send message to customer saying we are getting you a tuktuk
	

	# this method is triggered from the sms controller when a trip request is successfully made
	# this method is called after the trip request is saved in the dB
	def send_sms_ttrip_request 
		# make a new sms to request the trip
 		phone_number = self.phone_number
 		sent_sms = "Kuna Kazi, hapo #{self.location} Uko free? Jibu na Ndio au la"#check sms controller for the real sms
 		status  = "waiting" # this will change as soon as the driver responds appropriately
 		ttrip_request_id = self.id
 		received_sms = ""#get response from driver through sms controller

 		params = []
 		params << phone_number << sent_sms << ttrip_request_id << received_sms << status

 		save_params = ttrip_request_params params

 		sms = SmsTtripRequest.new(save_params)
 		sms.save
 		logger.debug "Created New SMS Tuktuk Trip Request"		
	end

	def start_trip
		# make a new trip
		trip_params_array  = []
		ttrip_request_id  = self.id
		status 			  = "started"
		trip_params_array << ttrip_request_id << status

		save_params = ttrip_params trip_params_array
		new_trip = Ttrip.new(save_params)
		new_trip.save

		# Make Driver availabilty to false.
		# The driver after completing the trip can then text back to update their availability status or 
		# TODO
		# automatically update this after 30mins
		self.tuktuk.update_attributes(status: "false")
		
		return new_trip
	end

	def get_driver_phone_number

		number = self.tuktuk.phone_number
		return number
	end

	def get_driver_first_name

		first_name = self.tuktuk.first_name
		return first_name
	end

	def get_transport_mode

		transport_mode =  self.sms.transport_mode
		return transport_mode
	end

	def get_current_location
		location = self.sms.current_location
		return location
	end

	def get_customer_number
		phone_number = self.phone_number
		return phone_number
	end

	# makeing work easier
	def trip
		return self.ttrip
	end

	def successful_trips
		# trips = Ttrip.where(ttrip_request_id: self.id, status: 'started')
		trips = self.ttrip_requests.where(status: 'started')
		total = trips.count

		if total == 0
			return total
		else
			return trips
		end
	end

	

	def responsiveness
		last_3_days = TtripRequest.where(created_at: 3.days.ago..Time.now, id: self.id)
		positive_response = last_3_days.where.not(status: 'failed').where.not(status: 'waiting')
		count = positive_response.count

		level = responsivenes_level count, last_3_days.count

		score = get_score level 
	end

	def self.responsive_drivers
		last_3_days = TtripRequest.where(created_at: 3.days.ago..Time.now)
		positive_response = last_3_days.where.not(status: 'failed').where.not(status: 'waiting')
		count = positive_response.count
		byebug
		# list_of_responsive_drivers should look like this dennis KBB WEWE => 5
		details = []
		score = []

		if count == 0
			return 0
		else
			positive_response.each do |req|
				resp = req.responsiveness
				# byebug
				
				first_name = req.tuktuk.id
				number_plate = req.tuktuk.number_plate
				details << first_name + " " + number_plate
				score << resp
			end

			list_of_responsive_drivers = Hash[*details.zip(score).flatten]
			# level = responsivenes_level count, last_3_days.count

			# score = get_score level 
			return list_of_responsive_drivers
		end
	end

######################
#
# TODO
# change waiting to failed in an hour. create cron job

######################

	def self.requests_today
		requests =TtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	# #######################################################################
	# 														                #
	# CANCELLED/ SUCCESSFUL/ FAILED/ WAITING REQUESTS (today, week, month ) #
	# 														                #
	# #######################################################################
	# ths gets all requests, failed or successful
	def requests_today
		requests = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	def self.waiting_requests_today
		requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'waiting')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
		
	end

	def self.success_requests_today
		requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
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

	# check number of completed requests today
	
	def self.completed_requests_today

		requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
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
	def self.cancelled_requests_today

		
		requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'cancelled')
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

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
	def self.week_success_requests
		
		requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "success")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

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
	def self.week_failed_requests
		
		requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "failed")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def week_failed_requests
		
		requests = self.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "failed")
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end


	def self.week_cancelled_requests

		
		requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now, status: 'cancelled')
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
	def self.month_success_requests
		requests =  TtripRequest.where(created_at: 1.month.ago..Time.zone.now, status: "success").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def month_success_requests
		requests =  self.where(created_at: 1.month.ago..Time.zone.now, status: "success").count
		total = requests.count

		if total == 0
			return total
		else
			return requests
		end
	end

	def self.month_failed_requests
		requests = TtripRequest.where(created_at: 1.month.ago..Time.zone.now, status: "failed").count
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

	def self.month_cancelled_requests
		requests = TtripRequest.where(created_at: 1.month.ago..Time.zone.now, status: "cancelled").count
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

	######################
	

protected

	# (positive response/total reequestst) * 100%

	def get_score level

		if level >=80
			p "very responsive"
			score = 4
			return score

		elsif level >=50 && level <=79
			p "responsive"
			score = 3
			return score

		elsif level >=30 && level <=49
			p "moderately reponsive"
			score = 2
			return score

		elsif level >=10 && level <=29
			p "Partially responsive"
			score = 1
			return score

		elsif level < 10 && level > 2
			p "Least responsive"
			score = 0.5
			return score

		else #less than 1
			#not responsive
			p "Not responsive"	
			score = 0
			return score
		end	
	end

	def responsivenes_level(positive_responses, total_requests)
		positive = positive_responses
		total = total_requests

		level = (positive / total) * 100

		return level
	end

	def ttrip_request_params data
		name = ["phone_number", "sent_sms", "ttrip_request_id", "received_sms", "status"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
		
	end



	def ttrip_params data
		name = ["ttrip_request_id", "status"]
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
end
