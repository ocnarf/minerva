class PubSubController < ApplicationController
	after_filter do
    puts response.body
	end

  #TODO: ok to suppress csrf?? Used for pshb to post/notify us of feed changes
  skip_before_filter :verify_authenticity_token, :only => [:notify]
  
  def subscribe 
  	pshb = SuperfeedrPshb::SuperfeedrPshb.new("minerva", "soymexicano", 
  		"http://67.180.177.165")
  	pshb.subscribe("/pub_sub/callback", "http://push-pub.appspot.com/feed", "superfeedtest")
  end

  def unsubscribe
    puts "unsubscribe"
    pshb = SuperfeedrPshb::SuperfeedrPshb.new("minerva", "soymexicano", 
      "http://67.180.177.165")
    pshb.unsubscribe("/pub_sub/callback", "http://push-pub.appspot.com/feed", "superfeedtest")
  end

  def callback
  	 
  end

  def validate
    puts "validate"
    if !params["hub.challenge"].nil?
       @challenge = params["hub.challenge"]
       render :action => "callback", :status => :ok, :layout => false
     else
       @challenge = "uhoh!"
       render :action => "callback", :status => 404
     end
  end

  def notify
    #logger.info request.env
    #logger.info "HEeeADERS: #{request.headers}"
    #logger.info("BODY: #{JSON.pretty_generate(JSON.parse(request.body.string))}")
    #Rails.logger.info("PARAMS: #{JSON.pretty_generate(params)}")

    #parse feed
    #feed = Feedzirra::Feed.parse(xml)
    puts "befor"
    Post.add_entry(params)
    puts "afte"
    
    render :action => "callback", :layout => false
  end

end
