Encoding.default_internal='UTF-8'
Encoding.default_external='UTF-8'
require 'rubygems'
#require 'bundler/setup'
require 'rake'
require 'platform_helpers'
require 'sinatra'
require 'warden'
BASE = File.expand_path(File.dirname(__FILE__))
require BASE + '/tunnel_limits'
Dir.entries(BASE + '/lib').each { |i| require "#{BASE}/lib/#{i}" if i =~ /\.rb$/ }
Dir.entries(BASE + '/models').each { |i| require "#{BASE}/models/#{i}" if i =~ /\.rb$/ }
require 'erb'
require 'yaml'
require 'json'
require 'openssl'
require 'rack'
require BASE + '/session_mgt'
require BASE + '/pm_vpn'
#require 'rack/flash'
#require 'unicorn'
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

map "/tunnel_limits" do
  run TunnelLimits
end
