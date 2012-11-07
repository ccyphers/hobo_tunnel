require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "list" do
    %w(one@email.com two@email.com).each { |email| User.create(:email => email) }

    g1 = Group.new
    g1.name = 'group1'
    g1.save

    g2 = Group.new
    g2.name = 'group2'
    g2.save


    ug = UserGroup.new
    ug.user_id=1
    ug.group_id=1
    ug.save

    get :list
    assert_response :success
    items = JSON.parse(response.body)
    keys = ['email', 'groups']
    items.each { |i|
      keys.each { |key| assert i.has_key?(key) }
    }

    assert !items.first['groups'].empty?
    assert items.last['groups'].empty?
    puts items.inspect
    assert !items.empty?, "There should be users returned"
  end


end
