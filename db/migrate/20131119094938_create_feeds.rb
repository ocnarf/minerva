class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url
      t.integer :hub_id

      t.timestamps
    end
  end
end
