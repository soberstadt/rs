Rs::Application.routes.draw do
  
  get 'carpool/login/:id'         => 'carpools#login', via: [:get, :post]
  get 'carpool/email'             => 'carpools#email'
  get 'carpool/email_submit'      => 'carpools#email_submit', via: [:get, :post]
  get 'carpool/get_coordinates'   => 'carpools#get_coordinates'
  get 'carpool/report'            => 'carpools#report'
  get 'carpool/register'          => 'carpools#register'
  get 'carpool/update_addresses'  => 'carpools#update_addresses', via: [:get, :update]
  get 'carpool/empty/:id'         => 'carpools#empty'
  get 'carpool/:id'               => 'carpools#index'
  get 'carpool'                   => 'carpools#index'
  
  root :to => 'carpool#index'

end

