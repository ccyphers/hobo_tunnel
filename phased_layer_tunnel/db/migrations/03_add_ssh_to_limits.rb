class AddSshToLimits < ActiveRecord::Migration
  def self.up
    add_column :limits, :ssh_type, :integer
    add_column :limits, :ssh_port, :integer
  end

  def self.down
  end
end
