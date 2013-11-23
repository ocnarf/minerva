class PubSubController < ApplicationController
	after_filter do
    puts response.body
	end

  @app_address = "http://67.180.176.71"
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
    self_url = parsed_feed.self_url

    # now that we have parsed the hub, add hub to feed record
    hub = parsed_feed.hub
    if !Hub.exists?( :url => hub )
      Hub.create( { :url => hub } )
      logger.info "hub created"
    end
    hub_id = Hub.where( { :url => hub} ).first.id

    # create a new feed entry with the self_url and hub
    logger.info "will create feed"
    new_feed = Feed.create( {:url => self_url, :hub_id => hub_id} )
    logger.info "did create feed"
    #feed_entry = Feed.where( { :url => self_url } ).first
    #feed_entry.update_attributes( :hub_id => hub_id )

  	pshb = SuperfeedrPshb::SuperfeedrPshb.new("minerva", "soymexicano", 
  		@app_address, hub)
    
  	pshb.subscribe("/pub_sub/callback", self_url, "superfeedtest")
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
    puts "validate"
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
