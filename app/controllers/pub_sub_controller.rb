class PubSubController < ApplicationController
	after_filter do
    puts response.body
	end

  @app_address = "http://getminerva.dyndns.org"
  #TODO: ok to suppress csrf?? Used for pshb to post/notify us of feed changes
  skip_before_filter :verify_authenticity_token, :only => [:notify]
  
  def self.subscribe(feed_url)
    # TODO: move to a initialize location where these will get called once
    logger.formatter = Logger::Formatter.new
    Feedzirra::Feed.add_common_feed_element(:link, :as => :hub, :value => :href, :with => {:rel => "hub"})
    Feedzirra::Feed.add_common_feed_element('atom10:link', :as => :hub, :value => :href, :with => {:rel => "hub"})
    Feedzirra::Feed.add_common_feed_element(:link, :as => :self_url, :value => :href, :with => {:rel => "self"})
    Feedzirra::Feed.add_common_feed_element('atom10:link', :as => :self_url, :value => :href, :with => {:rel => "self"})

    parsed_feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    
    # if there is no self link specified in feed use the feed_url
    topic_url = parsed_feed.self_url.blank? ? feed_url : parsed_feed.self_url
    #logger.info "parsed_feed.self exist: " + parsed_feed.self_url.blank? + " it is: " + parsed_feed.self_url
    
    # if there is no hub specified subscribe to superfeedr's default hub
    hub = parsed_feed.hub.blank? ? "http://push.superfeedr.com" : parsed_feed.hub
    logger.info "the hub we'll sub to: " + hub

    # if this is a new hub address, make a new record for it 
    if !Hub.exists?( :url => hub )
      Hub.create( { :url => hub } )
    end
    hub_id = Hub.where( {:url => hub} ).first.id

  	pshb = SuperfeedrPshb::SuperfeedrPshb.new("minerva", "soymexicano", @app_address, hub)
  	pshb.subscribe("/pub_sub/callback", topic_url, "superfeedtest")

    # TODO only create if subscribe is successful
    # create a new feed entry with the topic_url and hub
    Feed.create( {:url => topic_url, :hub_id => hub_id} )
  end

  def self.unsubscribe(feed_url)
    #TODO move logic around so feed record doesnt get destroyed untill after successful unsubscribe from 
    # hub? Then we can just use the hub corresponding to the feed record (no need to fetch_and_parse feed to
    # get hub)

    # TODO: move to a initialize location where these will get called once
    Feedzirra::Feed.add_common_feed_element(:link, :as => :hub, :value => :href, :with => {:rel => "hub"})
    Feedzirra::Feed.add_common_feed_element('atom10:link', :as => :hub, :value => :href, :with => {:rel => "hub"})
    Feedzirra::Feed.add_common_feed_element(:link, :as => :self_url, :value => :href, :with => {:rel => "self"})
    Feedzirra::Feed.add_common_feed_element('atom10:link', :as => :self_url, :value => :href, :with => {:rel => "self"})

    parsed_feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    pshb = SuperfeedrPshb::SuperfeedrPshb.new("minerva", "soymexicano", 
      @app_address, parsed_feed.hub)
    pshb.unsubscribe("/pub_sub/callback", feed_url, "superfeedtest")
  end

  def callback
  	 
  end

  def validate
    if !params["hub.challenge"].nil?
       @challenge = params["hub.challenge"]
       render :action => "callback", :text => @challenge, :status => :ok, :layout => false
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
    #Rails.logger.info("PARAMS: #{params.inspect}")

    #parse feed
    xml = request.body.string
    Post.add_entry(xml)

    render :action => "callback", :layout => false
  end

end
