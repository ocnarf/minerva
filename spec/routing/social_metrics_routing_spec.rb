require "spec_helper"

describe SocialMetricsController do
  describe "routing" do

    it "routes to #index" do
      get("/social_metrics").should route_to("social_metrics#index")
    end

    it "routes to #new" do
      get("/social_metrics/new").should route_to("social_metrics#new")
    end

    it "routes to #show" do
      get("/social_metrics/1").should route_to("social_metrics#show", :id => "1")
    end

    it "routes to #edit" do
      get("/social_metrics/1/edit").should route_to("social_metrics#edit", :id => "1")
    end

    it "routes to #create" do
      post("/social_metrics").should route_to("social_metrics#create")
    end

    it "routes to #update" do
      put("/social_metrics/1").should route_to("social_metrics#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/social_metrics/1").should route_to("social_metrics#destroy", :id => "1")
    end

  end
end
