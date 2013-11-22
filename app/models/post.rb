class Post < ActiveRecord::Base
  has_many :social_metrics
  belongs_to :feed
  belongs_to :site

  validates :url, uniqueness: { case_sensitive: false }


 # Creates new post entry based on entry hash pased in
 # entry - hash of all necessary parameters
 def self.add_entry(xml)
  feed = Feedzirra::Feed.parse(xml)
  #logger.info "raw entry xml: #{xml}"
  #logger.info "Feedzirra parse: #{feed.inspect}"

  feed.entries.each do |item|

    # follow url redirection to get final location of entry
    response = HTTParty.get(item.url)
    redirected_url = response.request.last_uri.to_s

    published = item.published.to_datetime
    host = URI.parse(redirected_url).host

    if !Site.exists?( :url => host)
      Site.create( {:url => host} )
    end

    site_id = Site.where( :url => host ).first.id

    Post.create( { :url => redirected_url, :published => published, :site_id => site_id } )
  end
 end

end