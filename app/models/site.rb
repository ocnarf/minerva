class Site < ActiveRecord::Base
  has_many :posts

  validates :url, uniqueness: { case_sensitive: false }

end
