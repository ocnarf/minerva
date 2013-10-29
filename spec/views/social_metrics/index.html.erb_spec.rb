require 'spec_helper'

describe "social_metrics/index" do
  before(:each) do
    assign(:social_metrics, [
      stub_model(SocialMetric,
        :context => "Context",
        :value => 1,
        :minutes_since_publish => 2,
        :post_id => 3
      ),
      stub_model(SocialMetric,
        :context => "Context",
        :value => 1,
        :minutes_since_publish => 2,
        :post_id => 3
      )
    ])
  end

  it "renders a list of social_metrics" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Context".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
