class Feed < ActiveRecord::Base
  has_many :posts
  belongs_to :hub

  before_create :subscribe_feed
  before_destroy :unsubscribe_feed

  validates :url, uniqueness: { case_sensitive: false }

  private
    
    # subscribe to the newly created feed
    def subscribe_feed
      PubSubController.delay.subscribe(self.url)
    end

    def unsubscribe_feed
      PubSubController.delay.unsubscribe(self.url)
    end

end