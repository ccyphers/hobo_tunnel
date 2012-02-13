require 'platform_helpers'
BASE = File.expand_path(File.dirname(__FILE__))
Dir.entries(BASE + '/lib').each { |i| require "#{BASE}/lib/#{i}" if i =~ /\.rb$/ }
Dir.entries(BASE + '/models').each { |i| require "#{BASE}/models/#{i}" if i =~ /\.rb$/ }
require 'erb'
require 'yaml'
require 'json'
require 'openssl'
require 'rack'
require 'warden'
require 'sinatra'
#require 'sinatra_warden'
require BASE + '/session_mgt'
require BASE + '/pm_vpn'
#require 'rack/flash'
DEBUG=false

use Rack::Session::Cookie, :secret => 'whatever'
use Rack::MethodOverride
use Warden::Manager do |manager|
manager.default_strategies :my_strategy
manager.failure_app = PoorMansVPN
end

map "/" do 
    run PoorMansVPN
end
