require 'open-uri'
require 'pp'
require 'digest'
require 'net/http'

class CarpoolController < ApplicationController
	def index
		if session[:event_id] != params[:id].to_i || params[:id].nil?
			unless params[:id].nil?
				@event = Event.find(:first, :conditions => {:conference_id => params[:id].to_i})
				if @event.nil?
					render :text => 'No registrants from your conference have registered with Rideshare yet.' and return
				end
				render :action => :login
			else
				render :text => '' and return
			end
		else
			#@drivers=Ride.find(:all, :conditions => {:drive_willingness => 1}, :include => :person)
			@drivers=Ride.find(:all, :conditions => {:drive_willingness => [1,3], :event_id => session[:event_local_id]}, :include => :person, :select => "*, id as outID, (SELECT count(*) FROM rideshare_ride WHERE driver_ride_id=outID and driver_ride_id != id) as numbercurrentpassengers") 
			@riders=Ride.find(:all, :conditions => {:drive_willingness => 0, :event_id => session[:event_local_id]}, :include => :person)
			@hidden_rides=Ride.find(:all, :conditions => {:drive_willingness => 2, :event_id => session[:event_local_id]}, :include => :person)
			@drivers.sort! { |a,b| (!a.special_info.blank? && !b.special_info.blank?) || (a.special_info.blank? && b.special_info.blank?)?(a.person.full_name+"" <=> b.person.full_name+""):((a.special_info.blank? && !b.special_info.blank?)?(1):(-1))}
			@riders.sort! { |a,b| (!a.special_info.blank? && !b.special_info.blank?) || (a.special_info.blank? && b.special_info.blank?)?(a.person.full_name+"" <=> b.person.full_name+""):((a.special_info.blank? && !b.special_info.blank?)?(1):(-1))}
			if @riders.size == 0 || @drivers.size == 0
				redirect_to :action => :empty
			end
			@spaces=0
			@riders_done=0
			@drivers.each do |driver|
				@spaces+=driver.number_passengers
				@riders_done+=driver.numbercurrentpassengers.to_i
			end 
			@latitude_avg=0
			@longitude_avg=0
			count=0
			@locations=Hash.new;
			@drivers.each do |driver|
				location=driver.latitude.to_s+" "+driver.longitude.to_s
				if !@locations.has_key?(location)
					@locations[location]={:latitude => driver.latitude, :longitude => driver.longitude, :rides => Array.new}
				end
				if (driver.latitude != 0 && driver.longitude != 0)
					@latitude_avg+=driver.latitude
					@longitude_avg+=driver.longitude
					count+=1
				end
				@locations[location][:rides].push({:type => "driver",:id => driver.id})
			end
			@riders.each do |rider|
				location=rider.latitude.to_s+" "+rider.longitude.to_s
				if !@locations.has_key?(location)
					@locations[location]={:latitude => rider.latitude, :longitude => rider.longitude, :rides => Array.new}
				end
				if (rider.latitude != 0 && rider.longitude != 0)
					@latitude_avg+=rider.latitude
					@longitude_avg+=rider.longitude
					count+=1
				end
				@locations[location][:rides].push({:type => "rider",:id => rider.id})
			end
			if count != 0
				@latitude_avg/=count
				@longitude_avg/=count
			else
				@latitude_avg=0
				@longitude_avg=0
			end
			@message=false
			@help_rides=Ride.find(:all, :conditions => {:latitude => 0, :longitude => 0, :event_id => session[:event_local_id]}, :include => :person)
			@message=true if @help_rides.size > 0
		end
	end
	
	def report
		if session[:event_id].nil?
			render :text => '' and return
		else
			@drivers=Ride.find(:all, :conditions => {:drive_willingness => 1, :event_id => session[:event_local_id]}, :include => :person, :select => "*, id as outID, (SELECT count(*) FROM rideshare_ride WHERE driver_ride_id=outID and driver_ride_id != id) as numbercurrentpassengers")
			@unassigned_riders=Ride.find(:all, :conditions => {:drive_willingness => 0, :driver_ride_id => 0, :event_id => session[:event_local_id]}, :include => :person)
		end
	end
	
	def email
		if session[:event_id].nil?
			render :text => '' and return
		else
			@event = Event.find(session[:event_local_id])
		end
	end
	
	def email_submit
		if session[:event_id].nil?
			render :text => '' and return
		else
			@event = Event.find(session[:event_local_id])
			@drivers=Ride.find(:all, :conditions => {:drive_willingness => 1, :event_id => session[:event_local_id]}, :include => :person, :select => "*, id as outID, (SELECT count(*) FROM rideshare_ride WHERE driver_ride_id=outID and driver_ride_id != id) as numbercurrentpassengers")
			@event.email_content = params[:content]
			@event.save!
			if params[:commit] == "Save"
				@notice = 'Email content successfully saved.'
			else
				@event.email_content = @event.email_content.gsub("\n", '<br />') if !@event.email_content.nil?
				@drivers.each do |driver|
					Email.deliver_car(driver.id)
				end
				@notice = 'Emails successfully sent.'
			end
		end
		render :action => "email" and return
	end
	
	def get_coordinates
		@rides=Ride.find(:all, :conditions => {:latitude => 0, :longitude => 0})
		sleep_time=1;
		@rides.each do |ride|
			address=(ride.address2 =~ /^\d/) ? ride.address2 : ride.address1
			@status, @accuracy, @latitude, @longitude=open("http://maps.google.com/maps/geo?q="+CGI::escape(address+", "+ride.city+", "+ride.state+" "+ride.zip)+"&output=csv&sensor=false&key="+GOOGLE_KEY).gets.split(',')
			sleep(sleep_time)
			if @status == 620
				sleep_time+=1
				redo
			end
			ride.latitude=@latitude
			ride.longitude=@longitude
			ride.save!
		end
		redirect_to :action => :index
	end
	
	def update_addresses
		params[:ride].each do |ride|
			temp=Ride.find(ride[1]['id'])
			temp.update_attributes(ride[1])
			temp.save!
		end
		get_coordinates
	end
	
	def update_address
		temp=Ride.find(params[:rideID])
		temp.address1=params[:address1]
		temp.address2=params[:address2]
		temp.city=params[:city]
		temp.state=params[:state]
		temp.zip=params[:zip]
		@status=620
		sleep_time=0
		while @status == 620
			address=(temp.address2 =~ /^\d/) ? temp.address2 : temp.address1
			@status, @accuracy, @latitude, @longitude=open("http://maps.google.com/maps/geo?q="+CGI::escape(address+", "+temp.city+", "+temp.state+" "+temp.zip)+"&output=csv&sensor=false&key="+GOOGLE_KEY).gets.split(',')
			sleep(sleep_time)
			if @status == 620
				sleep_time+=1
				redo
			end
		end
		temp.latitude=@latitude
		temp.longitude=@longitude
		temp.save!
		render :text => @latitude+','+@longitude
	end
	
	def add_rider
		begin
			rider=Ride.find(params[:rider].to_i)
			driver=Ride.find(params[:driver].to_i)
			if rider.drive_willingness == 0 && driver.drive_willingness == 1
				rider.driver_ride_id=driver.id
				rider.save!
				render :nothing => true
			else
				render :text => "failure"
			end
		rescue Exception=>e
			render :text => "failure"
		end
	end
	
	def remove_rider
		begin
			rider=Ride.find(params[:rider].to_i)
			rider.driver_ride_id=0;
			rider.save!
			render :nothing => true
		rescue Exception=>e
			render :text => "failure"
		end
	end
	
	def empty
	end
	
	
	#Registration Stuff
	def register
		if !params[:id].nil?
			ride=Ride.find(params[:id])
			if session[:event_id] != ride.event.conference_id
				render :text => "" and return
			end 
			person=ride.person
			@event=ride.event
			params[:redirect]="/"+ride.event.conference_id.to_s
			session[:redirect]=params[:redirect]
			session[:event]=@event.id
			session[:personID]=person.personID
		else
			session[:personID]=params[:person_id]
			session[:country]=params[:country]
			session[:phone]=params[:phone]
			session[:email]=params[:email]
			session[:gender]=params[:gender]
			session[:school_year]=params[:school_year]
			session[:redirect]=params[:redirect]
			session[:first_name]=params[:first_name]
			session[:last_name]=params[:last_name]
			session[:contact_method]=params[:contact_method]
			person=Person.find(:first, :conditions => {:personID => params[:person_id]})
			@event=Event.find(:first, :conditions => {:conference_id => params[:conference_id].to_i})
			if @event.nil?
				@event=Event.new(:email_content=>'',:event_name => params[:conference_name], :conference_id => params[:conference_id].to_i, :password => Digest::MD5.hexdigest("R1d3shar3"))
				@event.save!
			end
			session[:event]=@event.id
		end

		if !person.nil?
    			if person.first_name == params[:first_name] && person.last_name == params[:last_name] && (person.yearInSchool == params[:school_year]||(person.yearInSchool.nil?&&(params[:school_year]=="null"||params[:school_year]=="")) )
					ride=Ride.find(:first, :conditions => {:person_id => person.personID, :event_id => @event.id})
				end
				if !ride.nil?
					params[:situation]=(ride.drive_willingness == 0)? 'ride':(ride.drive_willingness == 1 || ride.drive_willingness == 3) ? 'drive':'done'
					#params[:time]=(ride.drive_willingness == 2) ? nil:ride.departureTime
					params[:time]=ride.departureTime
					if !params[:time].nil?
						params[:time_hour] = params[:time][0,2].to_i
						params[:time_minute] = params[:time][3,5].to_i
						if (params[:time_hour] < 12)
							params[:time_am_pm] = "AM"
						else
							params[:time_am_pm] = "PM"
							params[:time_hour] = params[:time_hour]-12
						end
					else
						params[:time_hour] = 12
						params[:time_minute] = 0
						params[:time_am_pm] = "PM"
					end
					params[:spaces]=ride.number_passengers
					params[:address_1]=ride.address1
					params[:address_2]=ride.address2
					params[:city]=ride.city
					params[:state]=ride.state
					params[:zip]=ride.zip
					params[:special_info]=ride.special_info
					params[:contact_method]=ride.contact_method
					params[:ride]=(ride.drive_willingness == 3) ? 'yes':'no'
					@done="You have already finished this registration. You can update your information here or <a href='"+params[:redirect]+"'>Go Back</a>"
				end
			#else
			#	render :text => "You seem to be trying to steal someone else's session." and return # invalid keys
			#end
		end
		# We need their name...
	end
	
	def register_submit
		errors = false
		@error = ''
		@event=Event.find(session[:event])
		if params[:situation] == "drive" || params[:situation] == "ride"
			if params[:situation] == "drive"
				if params[:spaces].blank?
					errors = true
					@error += "We need to know how many spaces you have.<br />"
				end
			end
#			if !(params[:time] =~ /^\d{1,2}:\d{2}$/)
#				errors = true
#				@error += "Time is incorrect format.<br />"
#			end
			if params[:contact_method].nil? || params[:contact_method].blank?
				errors = true
				@error += "Contact method was not chosen.<br />"
			end
			address=(params[:address_2] =~ /^\d/) ? params[:address_2] : params[:address_1]
      
   proxy_addr = PROXY_URL
    proxy_port = PROXY_PORT
    
     res=nil
    Net::HTTP::Proxy(proxy_addr, proxy_port).start("maps.google.com") {|http|
     res=http.get("/maps/geo?q="+CGI::escape(address+", "+params[:city]+", "+params[:state]+" "+params[:zip])+"&output=csv&sensor=false&key="+GOOGLE_KEY)
   }
  @status, @accuracy, @latitude, @longitude=res.body.to_s.split(',')
			if (@latitude == 0 && @longitude == 0)
				errors = true
				@error += "Your address cannot be located. Please update your address.<br />"
			end
		end
		if !errors
			person=Person.find(:first, :conditions => {:personID => session[:personID].to_i})

			ride=Ride.find(:first, :conditions => {:event_id => @event.id, :person_id => person.id})
			if !ride.nil? && params[:situation] != "drive"
				ride.rides.update_all :driver_ride_id => 0
			end
			if !ride.nil? && params[:situation] != "ride"
				ride.driver_ride_id=0
			end
			if !ride.nil? && params[:situation] == "drive" && params[:spaces].to_i < ride.rides.size
				# too many riders assigned for new passenger count
				if params[:spaces_count] == params[:spaces]
					ride.rides.update_all :driver_ride_id => 0
				else
					errors = true
					if session[:event_id] == ride.event.conference_id
						@error += "They have already been assigned more riders than that number of spaces. To remove everyone from their car and save the changes, click 'Finish Carpool Registration' again.<br />"
						@spaces_count = params[:spaces]
					else
						@error += "You have already been assigned more riders than that number of spaces. Please email your conference coordinator to inform them of your reduced seat count.<br />"
					end
				end
			end
		end
		if !errors
			if (params[:time_am_pm] == "PM")
				params[:time] = ((params[:time_hour].to_i)+12).to_s+":"+params[:time_minute]
			else
			  if(params[:time_hour].to_i<10)
			    params[:time] = "0"+params[:time_hour]+":"+params[:time_minute]
		    else
				  params[:time] = params[:time_hour]+":"+params[:time_minute]
			  end
			end

			if ride.nil?
				ride=Ride.new(:driver_ride_id => 0, :event_id => @event.id, :person_id => person.personID, :address1 => params[:address_1], :address2 => params[:address_2], :address3 => '', :address4 => '', :country => '', :city => params[:city], :state => params[:state], :zip => params[:zip], :latitude => @latitude, :longitude => @longitude, :phone => session[:phone], :contact_method => params[:contact], :number_passengers => ((params[:spaces].blank?)?0:params[:spaces]), :drive_willingness => (params[:situation] == "ride")?0:(params[:situation] == "drive")?(params[:ride] == 'yes')?3:1:2, :depart_time => params[:time], :special_info => params[:special_info], :email => session[:email])
				ride.save!
			else
				ride.address1=params[:address_1]
				ride.address2=params[:address_2]
				ride.city=params[:city]
				ride.state=params[:state]
				ride.zip=params[:zip]
				ride.latitude=@latitude
				ride.longitude=@longitude
				ride.contact_method=params[:contact_method]
				ride.number_passengers=((params[:spaces].blank?)?0:params[:spaces])
				ride.drive_willingness=(params[:situation] == "ride")?0:(params[:situation] == "drive")?(params[:ride] == 'yes')?3:1:2
				ride.depart_time=params[:time]
				ride.special_info=params[:special_info]
				ride.save!
			end
		end
		render :action => "register" and return if errors
		redirect_to session[:redirect]
	end
	
	def login
		@event = Event.find(:first, :conditions => {:conference_id => params[:id].to_i})
		if @event.nil?
			render :text => 'No registrants from your conference have registered with Rideshare yet.'
			return
		end
		if params[:key] && Digest::MD5.hexdigest(params[:key]) == @event.password
#			if request.env['REQUEST_METHOD'] == 'GET' && request.env['HTTP_REFERER'] && (request.env['HTTP_REFERER'].include?('conferenceregistrationtool.com') || request.env['HTTP_REFERER'].include?('crs.int.uscm.org')) 
				session[:event_id] = @event.conference_id
				session[:event_local_id] = @event.id
				redirect_to :controller => :carpool, :id => @event.conference_id, :action => :index and return
#			end
		end
	end
end