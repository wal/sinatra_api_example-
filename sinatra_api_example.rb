require 'rubygems'

# boot bundler

require "bundler"
Bundler.setup

require 'rack'
require 'sinatra'
require 'activerecord'
require 'rack/throttle'
require 'memcached'
require 'delayed_job'

#Memcached Config 
CACHE = Memcached.new
PREFIX = :throttle

# Enable New Relic    
configure :production do
  require 'newrelic_rpm'
end
                  

# rack_throttle config
MAX_REQUESTS_PER_HOUR = 3600

module Rack; 
  module Throttle
    class Hourly < TimeWindow
      def client_identifier(request)        
        # For rate limiting, Identify the client by ip address
        request.ip.to_s
      end      
    end
  end
end

# Add rack_throttle rack middleware
use Rack::Throttle::Hourly, :cache => CACHE, :code => 200, :key_prefix => PREFIX

                                           
# Active record config
Time.zone = "UTC"
ActiveRecord::Base.default_timezone = :utc
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig['production']

# Tell Delayed Job to use Active Record
Delayed::Worker.backend = :active_record

# Exceptional
require 'exceptional'
use Rack::Exceptional, EXCEPTIONAL_API_KEY if ENV['RACK_ENV'] == 'production'

# A ApiRequest Model that is persisted to the DB when received.
class ApiRequest < ActiveRecord::Base
  def perform      
    # Process API request (i.e queue request)                                                                                                                                          
  end  
end
   
# The API method
post '/api' do                
	Delayed::Job.enqueue ApiRequest.create!(params)
end

error do                                   
  Exceptional.handle_with_rack(request.env['sinatra.error'], request.env, request) 
end