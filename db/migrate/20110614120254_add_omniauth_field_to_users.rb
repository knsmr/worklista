class AddOmniauthFieldToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :remote_photo_url, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end

  def self.down
    remove_column :users, :remote_photo_url, :provider, :uid
  end
end
