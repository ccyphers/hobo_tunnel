class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def validate_on_create
    errors.add :user_id, "invalid user_id" unless user_id.valid_user
    errors.add :group_id, "invalid group_id" unless group_id.valid_group
  end
end
