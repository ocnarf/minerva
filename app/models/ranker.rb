class Ranker

  def self.rank(time_range)
    simple_max(time_range)
    #Post.joins(:social_metrics).select("posts.*, MAX(social_metrics.value) as value").where(posts: {published: time_range}, social_metrics: {context: 'fblike_count'}).group("posts.id").order("value desc")
  end

  def self.percent(time_range)
    self.percentile_rank(time_range)
  end

private

  def self.simple_max(time_range)
    Post.joins(:social_metrics).select("posts.*, MAX(social_metrics.value) as likes").where(posts: {published: time_range}, social_metrics: {context: 'fblike_count'}).group("posts.id").order("likes desc")
  end

  def self.above_average(time_range)
    Site.joins(:social_metrics).select("posts.*, AVG(social_metrics.value) avg, MAX(social_metrics.value) as value").where(posts: {published: time_range}, social_metrics: {context: 'fblike_count'}).group("sites.id").order("value desc")
    Post.joins(:latest_social_metric).select("posts.*, AVG(latest_social_metrics.fb_like_count) avg, MAX(latest_social_metrics.fb_like_count) as max_value").where(posts: {published: time_range}).group('site_id').order('max_value desc')
  end

  def self.percentile_rank(time_range)
     # get percentile for all posts
     post_percentile = Post.joins(:latest_social_metric).select('posts.id, posts.published, posts.site_id, posts.url,
      latest_social_metrics.fb_like_count AS likes,
      avg(latest_social_metrics.fb_like_count) OVER(PARTITION BY posts.site_id) AS AVG,
      RANK() OVER(PARTITION BY posts.site_id ORDER BY latest_social_metrics.fb_like_count) RANK,
      PERCENT_RANK() OVER(PARTITION BY posts.site_id ORDER BY latest_social_metrics.fb_like_count) pr,
      CUME_DIST() OVER(PARTITION BY posts.site_id ORDER BY latest_social_metrics.fb_like_count) CD ')

     # filter post created in time range and order by percentile
     top = post_percentile.where(posts: {published: time_range}).order('pr desc')
  end


end