base = File.expand_path(File.dirname(__FILE__))
require 'platform_helpers'
require 'active_record'
require 'yaml'
cfg=YAML::load_file(base + '/../config/database.yml')
ActiveRecord::Base.establish_connection(cfg['development'])

Dir.entries(base + '/../db/migrations').each { |i|
  next unless i =~ /\.rb$/
  p i
  klass = File.read(base + "/../db/migrations/#{i}").grep(/class/).first.split[1]
  begin
    require base + "/../db/migrations/#{i}"
    eval "#{klass}.up " 
  rescue => e
  end
}
