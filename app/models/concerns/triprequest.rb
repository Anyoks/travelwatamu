module Triprequest
	extend ActiveSupport::Concern

	def self.included(klass)
		klass.extend(ClassMethods)
	end

	module ClassMethods

		def responsive_drivers
			last_3_days = self.where(created_at: 3.days.ago..Time.now)
			positive_response = last_3_days.where.not(status: 'failed').where.not(status: 'waiting')
			count = positive_response.count
			
			# list_of_responsive_drivers should look like this dennis KBB WEWE => 5
			details = []
			score = []

			if count == 0
				return 0
			else
				positive_response.each do |req|
					resp = req.responsiveness
					# byebug
					if req.class.name == "Tuktuk"
						first_name = req.tuktuk.id
						number_plate = req.tuktuk.number_plate
					else
						irst_name = req.bajaj.id
						number_plate = req.bajaj.number_plate
					end

					details << first_name + " " + number_plate
					score << resp
				end

				list_of_responsive_drivers = Hash[*details.zip(score).flatten]
				# level = responsivenes_level count, last_3_days.count

				# score = get_score level 
				return list_of_responsive_drivers
			end
		end

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

			if total > 0

				level = (positive / total) * 100
			else
				return 0
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

		def waiting_requests_today
			requests = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'waiting')
			total = requests.count

			if total == 0
				return total
			else
				return requests
			end	
		end

		def success_requests_today
			requests = self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'success')
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
		
		def completed_requests_today

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

			
			requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: 'cancelled')
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
			
			requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "success")
			total = requests.count

			if total == 0
				return total
			else
				return requests
			end
		end



		# check Numnber of failed requests this week
		def week_failed_requests
			
			requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now,  status: "failed")
			total = requests.count

			if total == 0
				return total
			else
				return requests
			end
		end


		def week_cancelled_requests

			
			requests = TtripRequest.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now, status: 'cancelled')
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
			requests =  TtripRequest.where(created_at: 1.month.ago..Time.zone.now, status: "success").count
			total = requests.count

			if total == 0
				return total
			else
				return requests
			end
		end

		def month_failed_requests
			requests = TtripRequest.where(created_at: 1.month.ago..Time.zone.now, status: "failed").count
			total = requests.count
			if total == 0
				return total
			else
				return requests
			end
			
		end

		def month_cancelled_requests
			requests = TtripRequest.where(created_at: 1.month.ago..Time.zone.now, status: "cancelled").count
			total = requests.count

			if total == 0
				return total
			else
				return requests
			end
			
		end
	end

	def fail_trip

		logger.debug "Driver took too long to respond, Failing this trip"
		failing_trip = self

		failing_trip.update_attributes(status: "failed")
		return true
	end

	def responsiveness
		last_3_days = self.class.where(created_at: 3.days.ago..Time.now, id: self.id)
		positive_response = last_3_days.where.not(status: 'failed').where.not(status: 'waiting')
		count = positive_response.count

		level = self.class.responsivenes_level count, last_3_days.count

		score = self.class.get_score level 
	end

	# Getting Trip request details
	def get_customer_number
		phone_number = self.phone_number
		return phone_number
	end

	def get_driver_phone_number
		if self.class.name == "BtripRequest"
			number = self.bajaj.phone_number
		else
			number = self.tuktuk.phone_number
		end
		
		return number
	end

	def get_driver_first_name

		if self.class.name == "BtripRequest"
			first_name = self.bajaj.first_name
		else
			first_name = self.tuktuk.first_name
		end

		return first_name
	end

	def get_driver_id

		if self.class.name == "BtripRequest"
			driver_id = self.bajaj.id
		else
			driver_id = self.tuktuk.id
		end

		return driver_id
	end

	def get_transport_mode

		transport_mode =  self.sms.transport_mode
		return transport_mode
	end

	def get_current_location
		location = self.sms.current_location
		return location
	end

	def trip
		if self.class.name == "TtripRequest" 
			self.ttrip
		else
			self.btrip
		end
	end

	# getting sms_ttrip_request or sms_btrip_request
	def sms_trip_request
		if self.class.name == "TtripRequest" 
			self.sms_ttrip_request
		else
			self.sms_btrip_request
		end
	end

end