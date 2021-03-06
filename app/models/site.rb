class Site < ActiveRecord::Base
  has_many :posts
  has_many :social_metrics, :through => :posts
  has_many :latest_social_metrics, :through => :posts
  
  validates :url, uniqueness: { case_sensitive: false }

end
