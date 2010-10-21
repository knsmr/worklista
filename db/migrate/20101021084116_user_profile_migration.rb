class UserProfileMigration < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string   :name
      t.string   :title
      t.string   :twitter_id
      t.text     :description
      t.string   :website
    end
  end

  def self.down
    change_table(:users) do |t|
      t.remove   :name
      t.remove   :title
      t.remove   :twitter_id
      t.remove   :description
      t.remove   :website
    end
  end
end
