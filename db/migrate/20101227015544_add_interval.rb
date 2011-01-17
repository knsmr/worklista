class AddInterval < ActiveRecord::Migration
  def self.up
    add_column :items, :interval, :integer, :default => 180
  end

  def self.down
    remove_column :items, :interval
  end
end

