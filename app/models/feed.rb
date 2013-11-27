class Feed < ActiveRecord::Base
  has_many :posts
  belongs_to :hub

  before_destroy :unsubscribe_feed

  validates :url, uniqueness: { case_sensitive: false }

  def self.subscribe_to_feed(params)
    PubSubController.delay.subscribe(params[:url])
  end

  def self.resubscribe_all
    Feed.all.each do |feed|
     PubSubController.delay.subscribe(feed.url) 
    end
  end

  private

    def unsubscribe_feed
      PubSubController.delay.unsubscribe(self.url)
    end

end