class SocialMetric < ActiveRecord::Base
  belongs_to :post

  @fbmetrics = ['like_count', 'share_count', 'comment_count']

  def self.updateRecords
    Post.all.each do |post|
      oauth_access_token = 'CAACEdEose0cBANLZAA9jLpF8a4gZBFhKeqlpmra8dW3w76ZBRenZAZCZBtJly9yLLl6Gu9ZAnSH6RZBlQWPEroqAiBCGFKJphC4tTvu4EbrgDk5cKuKZBTBToTb47d4DqZCNq0QCzcYvX4ElBAG8jevJsfUfuN7SLG50jcbcak4CwcrWOZABdiisC6lpVBHk8RnsKAVggtvIo27NAZDZD'
      @api = Koala::Facebook::API.new(oauth_access_token)
      fql_query = 'SELECT url, normalized_url, click_count, share_count, like_count, comment_count, total_count, commentsbox_count, comments_fbid, click_count FROM link_stat WHERE url="' + post.url + '" '
      fql = @api.fql_query(fql_query)
      #puts "result: " + fql.inspect + " \n"

      # Make new metric entries for the values of each post
      @fbmetrics.each do |metric|
        context = 'fb' + metric
        value = fql[0][metric]
        min_since_publish = ((Time.now - post.created_at)/1.minute).round
        sm = SocialMetric.create( {:context => context, :value => value, :minutes_since_publish => min_since_publish, :post_id => post.id} )
        #puts "new sm: " + sm.inspect
      end

    end
  end    

end
