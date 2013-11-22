class Hub < ActiveRecord::Base
  has_many :feeds

  validates :url, uniqueness: { case_sensitive: false }
end
