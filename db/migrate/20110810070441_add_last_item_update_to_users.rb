class AddLastItemUpdateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_item_updated_at, :datetime, :default => (Time.now - 1.year)
    User.all.each do |u|
      items = u.items
      u.last_item_updated_at = 
        unless items.empty?
          items.map(&:created_at).max
        else
          Time.now - 1.year
        end
      u.save
    end
  end

  def self.down
    remove_column :users, :last_item_updated_at
  end
end
