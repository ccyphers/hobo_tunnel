class CreateUserLimits < ActiveRecord::Migration
  def change
    create_table :user_limits do |t|
      t.integer :user_id
      t.integer :limit_id
      t.timestamps
    end
  end
end
