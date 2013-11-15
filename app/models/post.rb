class Post < ActiveRecord::Base
	has_many :social_metrics


 # Creates new post entry based on entry hash pased in
 # entry - hash of all necessary parameters
 def self.add_entry(entries)
  puts "add entry"
 	entries["items"].each do |item|
    puts item.inspect
    url = item.has_key?("permalinkUrl") ? item["permalinkUrl"] : item["standardLinks"]["alternate"]["href"]
    published = DateTime.strptime(item["published"].to_s,'%s')
    puts "uuurl" + url
    puts "puublsi" + published.to_s
    Post.create( { :url => url, :published => published} )
  end
 end

end
