class UserLimit < ActiveRecord::Base
  belongs_to :user
  belongs_to :limit
end
