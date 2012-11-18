class CreateTravelsrsTable < ActiveRecord::Migration
  def change
  	create_table :rideshare_travelers do |t|
  		 t.string :type

  		 t.timestamps
  	end
  end

end
