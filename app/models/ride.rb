class Ride < ActiveRecord::Base
	self.table_name = "rideshare_ride"
	self.primary_key = "id"
	
	belongs_to :person, :foreign_key => "person_id"
	belongs_to :event, :foreign_key => "event_id"
	has_many :rides, :foreign_key => "driver_ride_id"
	
	def address
		returnval=address1
		returnval+="<br />"+address2 unless address2.empty?
		returnval+="<br />"+city+", "+state+" "+zip
	end
	
	def departureTime
		if (depart_time.nil?)
			"24:00"
		else
			if (depart_time.min < 10)
			  if (depart_time.hour < 10)
			    "0"+depart_time.hour.to_s+":0"+depart_time.min.to_s
			  else
			    depart_time.hour.to_s+":0"+depart_time.min.to_s
		    end
			else
			  if (depart_time.hour < 10)
			    "0"+depart_time.hour.to_s+":"+depart_time.min.to_s
	      else
				  depart_time.hour.to_s+":"+depart_time.min.to_s
			  end
			end
		end
	end
	def departureTimeNice
		if (depart_time.nil?)
			"12:00 AM"
		else
			if (depart_time.hour > 12)
				if (depart_time.min < 10)
					(depart_time.hour-12).to_s+":0"+depart_time.min.to_s+" PM"
				else
					(depart_time.hour-12).to_s+":"+depart_time.min.to_s+" PM"
				end
			else
				if (depart_time.min < 10)
				  # adding "0" to string for string substring operations, IE 01:15 AM
					depart_time.hour.to_s+":0"+depart_time.min.to_s+" AM"
				else
					depart_time.hour.to_s+":"+depart_time.min.to_s+" AM"
				end
			end
		end
	end
end
