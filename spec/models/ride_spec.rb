require 'spec_helper'

describe Ride do
   
   it { should belong_to :person }
   it { should belong_to :event }
   it { should have_many :rides }
end
