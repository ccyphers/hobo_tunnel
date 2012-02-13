base = File.expand_path(File.dirname(__FILE__))

require base + '/lib/db'
require base + '/models/user'
require base + '/models/limit'

puts User.find_by_email('email@blah.com')

begin
User.find(:all).each { |i| i.delete}
rescue => e
end
=begin
u = User.find(:all)
p u.inspect
exit
=end
u = User.new(:email => 'email@blah.com', :crypted_password => 'blah')
u.env_save
u.limits.create(:ssh_type => 'local', :ssh_port => 5900, :ssh_dport => 5900)
p u.errors.inspect

puts User.find(:all).length
