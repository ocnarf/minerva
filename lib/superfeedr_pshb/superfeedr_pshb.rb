# SupperfeedrPshb
require 'httparty'

module SuperfeedrPshb
  class SuperfeedrPshb
    include HTTParty
    attr_accessor :hub, :auth, :callback_root
    base_uri nil
 
    def initialize(username, password, callback_root, hub = "http://push.superfeedr.com")
      Rails.logger.info "pshb init hub: #{hub}"
      self.class.base_uri hub
      self.class.basic_auth username, password
      @auth = {:username => username, :password => password}
      @callback_root = callback_root
    end
    
    def create_and_send_request(type, mode_options)
      options = {:headers => {"Accept" => "application/json"}, :body => { 'hub.mode' => type, 'hub.verify' => "sync"} }
      options[:body].merge!(mode_options)
      Rails.logger.info "pshb hub: #{self.class.base_uri} parameters: " + options.inspect
      response = self.class.post('/', options)
      Rails.logger.info("Subscribe Response: " + response.inspect)
    end

    def subscribe(callback, topic, token)
      options = {'hub.callback' => @callback_root + callback, 'hub.topic' => topic, 'hub.verify_token' => token}
      create_and_send_request("subscribe", options)
    end
    
    def unsubscribe(callback, topic, token)
      options = {'hub.callback' => @callback_root + callback, 'hub.topic' => topic, 'hub.verify_token' => token}
      create_and_send_request("unsubscribe", options)
    end
  
  end
  
end