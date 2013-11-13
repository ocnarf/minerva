class PubSubController < ApplicationController
	after_filter do
    puts response.body
	end
  
  def subscribe 
  	puts "subscribing"
  	pshb = SuperfeedrPshb::SuperfeedrPshb.new("minerva", "soymexicano", 
  		"http://67.180.177.165")
  	pshb.subscribe("/pub_sub/callback", "http://push-pub.appspot.com/feed", "superfeedtest")
  end

  def callback
  	 if !params["hub.challenge"].nil?
       @challenge = params["hub.challenge"]
       render :action => "callback", :status => :ok, :layout => false
   	 else
  	   @challenge = "uhoh!"
       render :action => "callback", :status => 404
  	 end
  end

end
