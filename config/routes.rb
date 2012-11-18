Rs::Application.routes.draw do
  get "dashboard/index"
  root :to => 'carpools#index'

  # report controller convers rs1 "email" functionality
  # get "report/all"  
  # match 'carpool/report' => 'carpools#report'
  # match 'carpool/email' => 'carpools#email'
  # match 'carpool/email_submit' => 'carpools#email_submit'


  # shows an individual carpool group (IE, user logins and sees their carpool)
  # get "report/carpool"
  
  # returns list of people not registered for Rideshare
  # get "report/non_participants"


  # rs1 routes
  # match 'carpool/login/:id' => 'carpools#login'
  # match 'carpool/get_coordinates' => 'carpools#get_coordinates'
  # match 'carpool/register' => 'carpools#register'
  # match 'carpool/update_addresses' => 'carpools#update_addresses'
  # match 'carpool/:id' => 'carpools#index'
  
  # match 'carpool' => 'carpools#index'
end

