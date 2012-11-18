class Traveler < ActiveRecord::Base
	self.table_name_prefix = 'rideshare_'
	self.inheritance_column = :type
end