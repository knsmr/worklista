class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :url
      t.string :bitly_url
      t.string :title
      t.string :subtitle
      t.date :published_at
      t.text :summary
      t.integer :hatena
      t.integer :retweet
      t.text :private_memo
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
