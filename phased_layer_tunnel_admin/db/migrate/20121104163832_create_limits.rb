class CreateLimits < ActiveRecord::Migration
  def self.up
    create_table :limits do |t|
      t.integer :num_applications
      t.integer :ssh_type
      t.integer  :ssh_port
      t.integer :ssh_dport
      t.timestamps
    end
  end

  def self.down
    drop_table :limits
  end
end
