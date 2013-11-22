class SocialMetric < ActiveRecord::Base
  belongs_to :post

  @fbmetrics = ['like_count', 'share_count', 'comment_count']

  def self.update_records
    Post.all.each do |post|
      oauth_access_token = 'CAACEdEose0cBAKAiCMepwZANiYhrp8QykiYIHEDeV2RyKL7PlhTbJZCGusyyGEEvZAQEZBn4ZA860SnOxUnazQncey4aIbOL8HR3i80ZC0ZBYEHhMmUj8d9cTpllfZAgYMkKCrjV6haKl4cefxm8wq3xHvuvIfsZAOD6eh53vKSR9NthSUE7yFbCk0EXbN3Pekim2J6qrdeqzZAgZDZD'
      @api = Koala::Facebook::API.new
      fql_query = 'SELECT url, normalized_url, click_count, share_count, like_count, comment_count, total_count, commentsbox_count, comments_fbid, click_count FROM link_stat WHERE url="' + post.url + '" '
      fql = @api.fql_query(fql_query)
      #puts "result: " + fql.inspect + " \n"

      # Make new metric entries for the values of each post
      @fbmetrics.each do |metric|
        context = 'fb' + metric
        value = fql[0][metric]
        min_since_publish = ((Time.now - post.created_at)/1.minute).round
        sm = SocialMetric.create( {:context => context, :value => value, :minutes_since_publish => min_since_publish, :post_id => post.id} )
        puts "new sm: " + sm.inspect
      end

    end
  end    

end
