#module Engines
#  CONFIG = {:edge => true}
#end
# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
#ENV['RAILS_ENV'] ||= 'production'

RAILS_GEM_VERSION = '2.3.11'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
#require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here

  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options
  config.action_controller.session = { :key => "_fsk_session", :secret => "E120006572A95DADF978AAD334F824693EB96022133386FC18A06B5BFD601C22" }
end

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
#Engines.start :common_engine
ActionMailer::Base.smtp_settings = {
  :address   => "smtp1.ccci.org",
  :domain   => "ccci.org"
}
ExceptionNotifier.exception_recipients = %w(justin.sabelko@uscm.org)
ExceptionNotifier.sender_address = %(rs_error@uscm.org)
ExceptionNotifier.email_prefix = "[RS] "


# Set the default place to find file_column files.
FILE_COLUMN_PREFIX = 'files'
module FileColumn
  module ClassMethods
    DEFAULT_OPTIONS[:root_path] = File.join(RAILS_ROOT, "public", FILE_COLUMN_PREFIX)
    DEFAULT_OPTIONS[:web_root] = "#{FILE_COLUMN_PREFIX}/"
  end
end