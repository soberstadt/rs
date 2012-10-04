require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < Test::Unit::TestCase
  fixtures :fsk_orders, :fsk_products, :fsk_line_items
  
  def test_product_quantity
    order = Order.find(38)
    assert_equal order.product_quantity(36), 1000
  end

end
