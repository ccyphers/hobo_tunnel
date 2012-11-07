# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.delete_all
Group.delete_all
UserLimit.delete_all
UserGroup.delete_all
Limit.delete_all

users = [ {:email => 'blah1@email.com', :groups => ['Group 3']}]

20.times { |ct| g = Group.new ; g.name = "Group #{ct+1}"; g.save }

users.each { |user|
  u = User.create(:email => user[:email])
  if user.has_key?(:groups)
    user[:groups].each { |group|
      g = Group.find(:first, :conditions => {:name => group})
      ug = UserGroup.new
      ug.user_id = u.id
      ug.group_id = g.id
      ug.save
    }
  end
}
