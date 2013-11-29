class Ranker

  def self.rank(time_range)
    simple_max(time_range)
    #Post.joins(:social_metrics).select("posts.*, MAX(social_metrics.value) as value").where(posts: {published: time_range}, social_metrics: {context: 'fblike_count'}).group("posts.id").order("value desc")
  end

private

  def self.simple_max(time_range)
    Post.joins(:social_metrics).select("posts.*, MAX(social_metrics.value) as max_value").where(posts: {published: time_range}, social_metrics: {context: 'fblike_count'}).group("posts.id").order("max_value desc")
  end

  def self.above_average(time_range)
    Site.joins(:social_metrics).select("posts.*, AVG(social_metrics.value) avg, MAX(social_metrics.value) as value").where(posts: {published: time_range}, social_metrics: {context: 'fblike_count'}).group("sites.id").order("value desc")
    Post.joins(:latest_social_metric).select("posts.*, AVG(latest_social_metrics.fb_like_count) avg, MAX(latest_social_metrics.fb_like_count) as max_value").where(posts: {published: time_range}).group('site_id').order('max_value desc')
  end

  def self.percentile_rank(time_range)
     #LatestSocialMetric.select('latest_social_metrics.*, 100 * ROW_NUMBER() OVER (ORDER BY fb_like_count))/Count(*) AS percentile')
     #LatestSocialMetric.select('latest_social_metrics.*, (select count(*) from latest_social_metrics a where a.id >= latest_social_metrics.id) as rownum')
     #(select count(*) from tbl b  where a.id >= b.id) as cnt

     x= LatestSocialMetric.order('fb_like_count').select('latest_social_metrics.fb_like_count, (select count(*) from latest_social_metrics AS a where a.fb_like_count >= latest_social_metrics.fb_like_count) as row_num')
  end


end