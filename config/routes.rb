Rs::Application.routes.draw do
  
  match 'carpool/login/:id'         => 'carpools#login'
  match 'carpool/email'             => 'carpools#email'
  match 'carpool/email_submit'      => 'carpools#email_submit'
  match 'carpool/get_coordinates'   => 'carpools#get_coordinates'
  match 'carpool/report'            => 'carpools#report'
  match 'carpool/register'          => 'carpools#register'
  match 'carpool/update_addresses'  => 'carpools#update_addresses'
  match 'carpool/:id'               => 'carpools#index'
  match 'carpool'                   => 'carpools#index'
  
  root :to => 'carpool#index'

end

