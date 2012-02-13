class AddSshDestPortToLimits < ActiveRecord::Migration
  def self.up
    add_column :limits, :ssh_dport, :integer
  end

  def self.down
  end
end
