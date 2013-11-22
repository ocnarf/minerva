require 'spec_helper'

describe "feeds/new" do
  before(:each) do
    assign(:feed, stub_model(Feed,
      :url => "MyString",
      :hub_id => 1
    ).as_new_record)
  end

  it "renders new feed form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", feeds_path, "post" do
      assert_select "input#feed_url[name=?]", "feed[url]"
      assert_select "input#feed_hub_id[name=?]", "feed[hub_id]"
    end
  end
end
