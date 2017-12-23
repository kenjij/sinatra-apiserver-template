# Configure application logging
APIServer.logger = Logger.new(STDOUT)
APIServer.logger.level = Logger::DEBUG

APIServer::Config.setup do |c|
  # User custom data
  c.user = {my_data1: 'Something', my_data2: 'Somethingelse'}
  # Optional: if any number of strings are set, it will require a matching "?auth=" parameter in the incoming request
  c.auth_tokens = [
    'someSTRING1234',
    'OTHERstring987'
  ]
  # Handlers
  c.handler_paths = [
    File.expand_path('../../handlers', __FILE__)
  ]
  # HTTP server (Sinatra) settings
  c.dump_errors = true
  c.logging = true
end

APIServer::Config.shared.set_post_boot do
  # Post boot routine (called from Server.configure block)
  # if ENV['APP_ENV'] == 'production'
  #   require 'newrelic_rpm'
  #   GC::Profiler.enable
  # end
end
