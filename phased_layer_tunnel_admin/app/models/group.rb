class Group < ActiveRecord::Base
  belongs_to :user
  has_many :user_groups
  has_many :users, :through => :user_groups
  validates_uniqueness_of :name
  validates_presence_of :name

end
