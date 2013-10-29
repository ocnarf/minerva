require 'spec_helper'

describe "social_metrics/new" do
  before(:each) do
    assign(:social_metric, stub_model(SocialMetric,
      :context => "MyString",
      :value => 1,
      :minutes_since_publish => 1,
      :post_id => 1
    ).as_new_record)
  end

  it "renders new social_metric form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", social_metrics_path, "post" do
      assert_select "input#social_metric_context[name=?]", "social_metric[context]"
      assert_select "input#social_metric_value[name=?]", "social_metric[value]"
      assert_select "input#social_metric_minutes_since_publish[name=?]", "social_metric[minutes_since_publish]"
      assert_select "input#social_metric_post_id[name=?]", "social_metric[post_id]"
    end
  end
end
