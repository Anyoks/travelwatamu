module Driver
	extend ActiveSupport::Concern

	def self.included(klass)
		klass.extend(ClassMethods)
	end

	module ClassMethods
		def get_driver_for_this_trip

			# availability (2) + no Trips (1) + responsiveness (4) + completed trips (3)  = score (10)
			
			available_drivers = self.available # score 1

			# what if there's no free driver?
			if available_drivers.size == 0
				logger.debug "Could not find available drivers"

				# TODO , SELECT DRIVER WHOSE TRIP IS ABOUT TO END, MAYBE?
				return false
			else
				score_level_2 = self.trips_today available_drivers # score 2

				score_level_3 = self.get_responsiveness_for_list score_level_2 # score 4
				score_level_4 = get_completed_trips_for_list score_level_3 #score 3

				sorted_list = score_level_4.sort {|a,b| a[1]<=>b[1]}.reverse #in desc from highest to lowest

				top = sorted_list[0][0] # we will send the driver that is top of the list

				driver = self.find(top)
				
				return driver
			end
		end

		def trips_today tuktuks
			# id/plate => trips_today
			details = []
			score_today = []
			
			tuktuks.each do |tuk|
				trips = tuk.success_requests_today(data: false) 
				score = 1 #becaise they are already available they get an automatic score of 1
				# adding score
					if trips < 1
						score += 1			
					end
				driver = tuk.id
				number_plate = tuk.number_plate
				

				details << driver
				score_today << score
			end
			
			tuktuks_trips_asc = Hash[*details.zip(score_today).flatten] # I'll have to factor in the data false in here.
		
			return tuktuks_trips_asc#.sort {|a,b| a[1]<=>b[1]}.reverse #a list the tuktuks with 0 to highest trips today 
		end

		# (positive response/total reequestst) * 100%

		def get_score level, method
			case method

			when "responsiveness"
					
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
			when "completness"
				if level >=80
					p "very Productive"
					score = 3
					return score

				elsif level >=50 && level <=79
					p "Productive"
					score = 2
					return score

				elsif level >=30 && level <=49
					p "moderately Productive"
					score = 1
					return score

				elsif level >=10 && level <=29
					p "Partially Productive"
					score = 0.5
					return score

				elsif level < 10 && level > 2
					p "Least Productive"
					score = 0.1
					return score

				else #less than 1
					#not responsive
					p "Not Productive"	
					score = 0
					return score
				end	
			else
				p "No options selected"
				return
			end
		end

		# this gets the percentage
		def responsivenes_level(positive_responses, total_requests)
			positive = positive_responses
			total = total_requests

			if total == 0
				level = 0
			else
				level = (positive / total) * 100
			end

			return level
		end

		def get_responsiveness_for_list( hash = {})
			 # arr = array
			 # get responsiveness score for each id
			 hash.each do |id, score|
			 	resp = get_responsiveness id
			 	hash[id] += resp
			 end

			return hash
		end

		def get_responsiveness id
			tuktuk = self.find(id)
			last_3_days = tuktuk.ttrip_requests.where(created_at: 3.days.ago..Time.now)
			positive_response = last_3_days.where.not(status: 'failed').where.not(status: 'waiting')
			count = positive_response.count

			level = responsivenes_level count, last_3_days.count

			score = get_score level, "responsiveness"
			return score
		end

		def get_completed_trips id
			tuktuk = self.find(id)
			last_3_days = tuktuk.ttrip_requests.where(created_at: 3.days.ago..Time.now)
			completed_trips = tuktuk.ttrips.where(status: 'started')
			total = completed_trips.count

			level = responsivenes_level completed_trips.count, total
			score = get_score level, "completness"

			return score
		end

		def get_completed_trips_for_list( hash = {})

			hash.each do |id, score|
				trip = get_completed_trips id
				hash[id] += trip
			end
			
			return hash
		end

		def completed_trips
			# kombe KBM => 5
			details = []
			total = []
			self.all.each do |tuk|
				trips = tuk.ttrips.where(status: 'started') # change this ot completed when we implement driver complete 
				driver_name = tuk.first_name
				number_plate = tuk.number_plate
				total_trips = trips.count

				details << driver_name + " " + number_plate
				total << total_trips
			end
			
			list_of_completed_trips = Hash[*details.zip(total).flatten]

			return list_of_completed_trips.sort {|a,b| a[1]<=>b[1]}.reverse

		end

	end
end
