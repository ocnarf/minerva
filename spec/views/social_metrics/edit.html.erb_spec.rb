require 'spec_helper'

describe "social_metrics/edit" do
  before(:each) do
    @social_metric = assign(:social_metric, stub_model(SocialMetric,
      :context => "MyString",
      :value => 1,
      :minutes_since_publish => 1,
      :post_id => 1
    ))
  end

  it "renders the edit social_metric form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", social_metric_path(@social_metric), "post" do
      assert_select "input#social_metric_context[name=?]", "social_metric[context]"
      assert_select "input#social_metric_value[name=?]", "social_metric[value]"
      assert_select "input#social_metric_minutes_since_publish[name=?]", "social_metric[minutes_since_publish]"
      assert_select "input#social_metric_post_id[name=?]", "social_metric[post_id]"
    end
  end
end
