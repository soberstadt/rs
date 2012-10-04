# require File.expand_path(File.dirname(__FILE__) + '/unit')

#Unit tests.
require File.expand_path(File.dirname(__FILE__) + '/unit/fsk_user_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/kit_category_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/line_item_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/order_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/product_order_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/report_record_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/regional_report_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/national_report_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/unit/report_record_test.rb')

#Functional tests.
require File.expand_path(File.dirname(__FILE__) + '/functional/customer/allocation_controller_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/functional/customer/order_controller_test.rb')
require File.expand_path(File.dirname(__FILE__) + '/functional/customer/summary_controller_test.rb')