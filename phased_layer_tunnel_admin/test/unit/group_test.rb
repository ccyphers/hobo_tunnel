require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "group must have a valid name" do
    g = Group.new
    assert !g.valid?
    assert_equal "name has already been taken", g.errors.first.join(' ')
    g.name='blah'
    assert g.valid?
  end

  test "two groups can not have the same name" do
    g1 = Group.new
    g1.name = 'group1'
    assert g1.errors.empty?
    g1.save
    g2 = Group.new
    g2.name = 'group1'
    assert !g2.valid?
    assert_equal "name has already been taken", g2.errors.first.join(' ')
    g1.delete
    g2.delete
  end
end
