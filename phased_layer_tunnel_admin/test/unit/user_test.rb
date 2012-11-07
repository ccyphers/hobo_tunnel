require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user must have an email address" do
    u = User.new
    assert !u.valid?
    assert_equal "email can't be blank", u.errors.first.join(' ')
    u.email='blah@blah.com'
    assert u.valid?
  end

  test "user must have a valid email format" do
    u = User.new
    u.email='blah'
    assert !u.valid?
    assert_equal "email please provide a valid email format.", u.errors.first.join(' ')
    u.email='blah@blah.com'
    assert u.valid?
  end

  test "two users can not have the same email address" do
    u = User.create(:email => 'blah@blah.com')
    puts "BLAH: #{u.errors.first.inspect}"
    assert u.errors.empty?
    u2 = User.create(:email => 'blah@blah.com')
    assert !u2.errors.empty?
    assert_equal "email has already been taken", u2.errors.first.join(' ')
    u.delete
  end
=begin
  test "a user can have zero or more limits" do
    u = User.create(:email => 'blah@blah.com')
    assert u.limits.empty?
    10.times { |ct|
      u.limits.create
      assert u.limits.length == ct+1
    }
    u.delete
  end

  test "a user can have zero or more groups" do
    u = User.create(:email => 'blah@blah.com')
    assert u.groups.empty?
    10.times { |ct|
      u.groups.create
      assert u.groups.length == ct+1
    }
    u.delete
  end
=end
end
