class ReportController < ApplicationController
  # TODO before_filter for auth

  def all
		if session[:event_id].nil?
			render :text => '' and return
		else
			@drivers=Ride.find(
					:all, 
					:include => :person,
					:conditions => {
						:drive_willingness => 1, 
						:event_id => session[:event_local_id]},
					:select => "*, id as outID, (SELECT count(*) FROM rideshare_ride WHERE driver_ride_id=outID and driver_ride_id != id) as numbercurrentpassengers")
			@unassigned_riders=Ride.find(
				:all, 
				:include => :person,
				:conditions => {
					:drive_willingness => 0, 
					:driver_ride_id => 0, 
					:event_id => session[:event_local_id]}
				)
		end
  end

  # TODO provide a rideshare_ride.id, ensure user is in group,
  # then show the group's rider(s) and driver
  def carpool
  end

	# TODO the same idea as def all, but only those who self declared to not
	# use rideshare
  def non_participants
  end

end
