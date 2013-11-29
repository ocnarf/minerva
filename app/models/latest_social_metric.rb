class LatestSocialMetric < ActiveRecord::Base
 belongs_to :post

 @fbmetrics = ['like_count', 'share_count', 'comment_count']

 class << self

    def update_records
      @oauth = Koala::Facebook::OAuth.new('395731663893021', '2db748baec8b0a2197703510542c906f')
      @token = @oauth.get_app_access_token
      @api = Koala::Facebook::API.new(@token)

      Post.find_each do |post|
        #logger.info "gettting SM for Post: #{post.id}"
        
        fql_query = 'SELECT url, normalized_url, click_count, share_count, like_count, comment_count, total_count, commentsbox_count, comments_fbid, click_count FROM link_stat WHERE url="' + post.url + '" '
        fql = @api.fql_query(fql_query)

        # Get record for this post or make a new one if it does not exist
        lsm = LatestSocialMetric.find_or_initialize_by(post_id: post.id)

        fbl = "fb_#{@fbmetrics[0]}"
        fbs = "fb_#{@fbmetrics[1]}"
        fbc = "fb_#{@fbmetrics[2]}"

        fbl_val = fql[0][@fbmetrics[0]]
        fbs_val = fql[0][@fbmetrics[1]]
        fbc_val = fql[0][@fbmetrics[2]]

        lsm.update_attributes( { fbl => fbl_val, fbs => fbs_val, fbc => fbc_val } )
        lsm.save
      end
    end 
    handle_asynchronously :update_records

  end 

end
