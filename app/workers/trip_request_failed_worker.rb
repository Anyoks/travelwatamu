class TripRequestFailedWorker
  include Sidekiq::Worker

  def perform(trip_request_id, transport_mode)#(*args)
    # Do something
    if transport_mode == "tukutuku"
    	request = TtripRequest.find(trip_request_id)
    	if request.status == "waiting"
    		logger.debug "None responsive Tuktuk Driver, failing Trip"
    		request.fail_trip
	    end
    else
    	request = BtripRequest.find(trip_request_id)
    	if request.status == "waiting"
    		logger.debug "None responsive Tuktuk Driver, failing Trip"
	    	request.fail_trip
    	end
    end
  end
end
