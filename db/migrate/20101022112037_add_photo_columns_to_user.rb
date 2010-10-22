class AddPhotoColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :photo_file_name,    :string
    add_column :users, :photo_content_type, :string
    add_column :users, :photo_file_size,    :integer
    add_column :users, :photo_updated_at,   :datetime
  end

  def self.down
    add_column :users, :photo_file_name
    add_column :users, :photo_content_type
    add_column :users, :photo_file_size
    add_column :users, :photo_updated_at
  end
end

