class CreatRideShareRideGroupTable < ActiveRecord::Migration
  def change
		create_table :rideshare_ride_groups do |t|
			t.integer :rideshare_event_id
			t.integer :rideshare_email_id

			t.timestamps
		end
  end
end
