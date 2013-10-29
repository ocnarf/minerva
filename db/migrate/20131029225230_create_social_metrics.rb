class CreateSocialMetrics < ActiveRecord::Migration
  def change
    create_table :social_metrics do |t|
      t.string :context
      t.integer :value
      t.integer :minutes_since_publish
      t.integer :post_id

      t.timestamps
    end
  end
end
