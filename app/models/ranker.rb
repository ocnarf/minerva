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

  end

end