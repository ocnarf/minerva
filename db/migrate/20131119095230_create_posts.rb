class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :url
      t.datetime :published
      t.integer :feed_id
      t.integer :site_id

      t.timestamps
    end
  end
end
