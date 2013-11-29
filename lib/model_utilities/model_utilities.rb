class ModelUtilities

  def self.posts_per_site
    # Can do the query in both of these ways, is there a significant difference?
    #post = Post.includes(:site).select(:site_id, 'COUNT(*) AS total').group(:site_id)
    sites = Site.joins(:posts).select('sites.*, COUNT(*) AS total').group('sites.id')
    
    a = {}
    sites.each do |s|
      #a[s.url] = s.total
      a[s.id] = s.total
    end

    a
  end

end
