class AddPick < ActiveRecord::Migration
  def self.up
    add_column :items, :pick, :boolean, :default => false
  end

  def self.down
    remove_column :items, :pick
  end
end
