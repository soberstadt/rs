require File.dirname(__FILE__) + '/../../test_helper'
require 'customer/order_controller'

# Re-raise errors caught by the controller.
class Customer::OrderController; def rescue_action(e) raise e end; end

class Customer::OrderControllerTest < Test::Unit::TestCase
  fixtures :simplesecuritymanager_user, :fsk_products, :fsk_kit_categories, :fsk_orders, :fsk_line_items
  def setup
    @controller = Customer::OrderController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @kit_products = {"35"=>"0",       #category 12: books
                     "36"=>"1000",    #category 12: books
                     "23"=>"1000",    #category 6
                     "43"=>"1000",    #category 14
                     "17"=>"1000",    #category 5
                     "31"=>"1000",    #category 11
                     "15"=>"1000",    #category 1: laundry bag
                     "40"=>"1000",    #category 13: music
                     "8"=>"1000"}    #category 4: bottles
    @individual_products = {"46"=>"1000",     #category 16
                     "47"=>"0",               #category 16
                     "23"=>"1000",            #category 6
                     "43"=>"1000"}            #category 14
    @kit_order = {"order"=>
                          {"ship_address1"=>"123 Somewhere St", 
                           "ship_phone"=>"32423-1", 
                           "ship_address2"=>"#3304", 
                           "project_id"=>"4", 
                           "ship_zip"=>"12231", 
                           "contact_cell"=>"777-HEAVEN", 
                           "total_kits"=>"1000", 
                           "operating_unit"=>"2", 
                           "business_unit"=>"1", 
                           "ship_state"=>"AK", 
                           "contact_last_name"=>"You", 
                           "ship_first_name"=>"Matt", 
                           "ship_last_name"=>"Drees", 
                           "ship_city"=>"Jupiter", 
                           "type"=>"KitOrder", 
                           "contact_phone"=>"555-LOVE", 
                           "contact_first_name"=>"Me", 
                           "contact_email"=>"josh.starcher@uscm.org", 
                           "dept_id"=>"3", 
                           "location_name"=>"Here",
                           "allocation_id"=>3},
                        "products"=> @kit_products                          
                      }
    @product_order = @kit_order.dup
    @product_order["order"]["type"] = "ProductOrder"
    @product_order["products"] = @individual_products
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user] = User.find(:first)
  end

  def test_place_kit_order
    get :place_kit_order, {'allocation_id'=>3}
    assert_response :success
  end
  
  def test_place_product_order
    get :place_product_order
    assert_response :success
  end
  
  def test_create_kit_order
    post :create_kit_order, @kit_order
    successful_order
  end
  
  def test_create_kit_order_with_bad_order
    @kit_order["order"]["location_name"] = ''
    post :create_kit_order, @kit_order
    assert_response :success
    assert assigns["order"].errors.count == 1
  end
  
  def test_create_product_order
    post :create_product_order, @product_order
    successful_order
  end
  
  def test_edit_kit_order
    get :edit_kit_order, {:id => 38}
    assert_response :success
  end
  
  def test_edit_product_order
    get :edit_product_order, {:id => 39}
    assert_response :success
  end
  
  def test_update_kit_order
    @kit_order["id"] = 38
    post :update_kit_order, @kit_order
    successful_order
  end
    
  def test_update_kit_order_with_too_many_of_an_item_in_a_category
    @kit_order["products"]["35"] = 500
    @kit_order["id"] = 38
    post :update_kit_order, @kit_order
    assert_response :success
    assert_equal(assigns["order"].errors.count, 1)
  end
  
  def test_update_product_order
    @product_order["id"] = 39
    post :update_kit_order, @product_order
    successful_order
  end
  
  # def test_update_product_order_quantity_not_mod_100
  #   @product_order["id"] = 39
  #   @product_order["products"]["5"] = 1    
  #   post :update_product_order, @product_order
  #   assert_response :success
  #   assert assigns["line_item_errors"].size == 1
  # end
  
  def test_update_product_order_quantity_too_large
    @product_order["id"] = 39
    @product_order["products"]["5"] = 100000   
    post :update_product_order, @product_order
    assert_response :success
    assert assigns["line_item_errors"].size == 1
  end
  
  def test_field_length_validation_for_kit_order
    @kit_order["order"]["contact_phone"] = '12345678901234567890123456'
    post :create_kit_order, @kit_order
    assert_response :success
    assert assigns["order"].errors.count == 1
  end
  def test_update_line_item_quantity
    @order = ProductOrder.find(39)
    @item_quantity = @order.line_items.find(1).quantity
    @product_order["id"] = 39
    post :update_product_order, @product_order
    @order = ProductOrder.find(39)
    # After updating this order, the line item quantity should change.
    assert_not_equal @order.line_items.find(1).quantity, @item_quantity
  end
  def test_order_less_items_than_kits
    @kit_order["products"]["23"] = nil
    post :create_kit_order, @kit_order
    #p assigns["order"].errors
    assert_response :success
    assert_equal assigns["order"].errors.count, 1
  end
end
