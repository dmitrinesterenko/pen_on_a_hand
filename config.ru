require './contacts.rb'
require 'better_errors'
require 'rack'
require 'camping'
use BetterErrors::Middleware
BetterErrors.application_root = __dir__
run Contacts
#run Rack::Adapter::Camping.new(Contacts)
