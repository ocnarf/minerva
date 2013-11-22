class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|
      t.string :url

      t.timestamps
    end
  end
end
