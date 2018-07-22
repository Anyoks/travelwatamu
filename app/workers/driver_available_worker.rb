class DriverAvailableWorker
  include Sidekiq::Worker

  def perform(driver_id, transport_mode) #(*args)
    # Do something
    # 
    if transport_mode ==  "tukutuku"
    	# make a Tuktuk driver available
    	tukdriver =  Tuktuk.find(driver_id)
    	tukdriver.make_available
    else
    	# make a Bajaj driver available
    	bajdriver = Bajaj.find(driver_id)
    	bajdriver.make_available
    end
  end

  # worker to change all waiting requests to failed after 20 minutes
end
