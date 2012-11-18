class MakeEventAndRideTablenamesPlural < ActiveRecord::Migration
  def change
  	rename_table :rideshare_ride, :rideshare_rides
  	rename_table :rideshare_event, :rideshare_events
  end
end
