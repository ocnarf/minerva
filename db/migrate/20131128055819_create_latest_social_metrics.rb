class CreateLatestSocialMetrics < ActiveRecord::Migration
  def change
    create_table :latest_social_metrics do |t|
      t.integer :post_id
      t.integer :fb_like_count
      t.integer :fb_share_count
      t.integer :fb_comment_count

      t.timestamps
    end
  end
end
