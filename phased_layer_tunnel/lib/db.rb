require 'active_record'
require 'yaml'
require 'platform_helpers'
base = File.expand_path(File.dirname(__FILE__))
require base + '/log'
cfg = YAML::load_file(base + '/../config/database.yml')
HTTP_ENV ||= 'development'
ActiveRecord::Base.establish_connection(cfg[HTTP_ENV])
