class Email < ActionMailer::Base
	
	def car(driver_ride_id)
		driver = Ride.find(driver_ride_id)
		event = Event.find(driver.event_id)
		emails = []
		emails << driver.email
		driver.rides.each do |rider|
			emails << rider.email
		end
		
		@from = 'no-reply@ride.uscm.org'
		@recipients = emails.join(',')
		@subject = 'Ride information for '+event.event_name
		@body['driver'] = driver
		@body['event'] = event
		@content_type = "text/html"
	end

end
