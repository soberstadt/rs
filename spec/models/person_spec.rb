require 'spec_helper'

describe Person do

	it { should have_one :current_address } 
	it { should have_one :permanent_address }
	it { should have_one :emergency_address1 }
	it { should have_many :addresses }
		
end