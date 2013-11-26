class SocialMetric < ActiveRecord::Base
  belongs_to :post

  @fbmetrics = ['like_count', 'share_count', 'comment_count']

  class << self

    def update_records
      @oauth = Koala::Facebook::OAuth.new('395731663893021', '2db748baec8b0a2197703510542c906f')
      @token = @oauth.get_app_access_token
      @api = Koala::Facebook::API.new(@token)

      Post.all.each do |post|
        #logger.info "gettting SM for Post: #{post.id}"
        
        fql_query = 'SELECT url, normalized_url, click_count, share_count, like_count, comment_count, total_count, commentsbox_count, comments_fbid, click_count FROM link_stat WHERE url="' + post.url + '" '
        fql = @api.fql_query(fql_query)
        #puts "result: " + fql.inspect + " \n"

        # Make new metric entries for the values of each post
        @fbmetrics.each do |metric|
          context = 'fb' + metric
          value = fql[0][metric]
          min_since_publish = ((Time.now - post.created_at)/1.minute).round
          sm = SocialMetric.create( {:context => context, :value => value, :minutes_since_publish => min_since_publish, :post_id => post.id} )
        end
      end
    end 
    handle_asynchronously :update_records

  end   

end
