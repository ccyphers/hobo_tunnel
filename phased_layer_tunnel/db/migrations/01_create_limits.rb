class CreateLimits < ActiveRecord::Migration
  def self.up
    create_table :limits do |t|
      t.integer :user_id
      t.integer :num_applications
      t.timestamps
    end
  end

  def self.down
    drop_table :limits
  end
end
