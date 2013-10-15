Airbrake.configure do |config|
  config.api_key     = 'dbd5149a781c02341a9646b8e291379b'
  config.host        = 'errors.uscm.org'
  config.port        = 443
  config.secure      = config.port == 443
end

