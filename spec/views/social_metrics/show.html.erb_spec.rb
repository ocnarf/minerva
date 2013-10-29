require 'spec_helper'

describe "social_metrics/show" do
  before(:each) do
    @social_metric = assign(:social_metric, stub_model(SocialMetric,
      :context => "Context",
      :value => 1,
      :minutes_since_publish => 2,
      :post_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Context/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
