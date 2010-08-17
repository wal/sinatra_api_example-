require File.join(File.dirname(__FILE__), '..', 'sinatra_api_example.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, :false


include Rack::Test::Methods

def app
  Sinatra::Application
end
  
