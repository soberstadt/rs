## Ridesahre

### Passwords and API Keys
This applicaiton requires initialization of 2 constants, RIDESHARE_PASSWORD
and GOOGLE_MAPS2_KEY. Locations for both files are provided below,  
* app/config/initializers/password.rb.example  
* app/config/initializers/google.rb.example  

In order to correctly set these values for your application, remove the
example part (EG, password.rb.example -> password.rb) and provide a
constant.  
  
You will need to obtain a Google Maps 2.0 key and set the GOOGLE_MAPS2_KEY
constant to your private API key.

### Development Environment
Rideshare is a session based application that inherits session variables from 
CRS. To work on the rails app apart from CRS defining the session for you, 
define desired session parameters via HTTP params. For example, 
    
    git clone git@github.com:thelabtech/rs.git
    
    # setup 
    ## database.yml
    ## google.rb
    ## password.rb
    
    cd rs
    
    rails server # defaults to "development" env
    
Go to [http://localhost:3000/carpool/1045?event_id=1045&event_local_id=20]
(http://localhost:3000/carpool/1045?event_id=1045&event_local_id=20).
    
The controller sets the session params according to defined HTTP params. The 
code that does this is here, 
    
### Testing

### Production 
