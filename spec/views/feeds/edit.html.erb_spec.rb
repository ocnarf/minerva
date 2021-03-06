require 'spec_helper'

describe "feeds/edit" do
  before(:each) do
    @feed = assign(:feed, stub_model(Feed,
      :url => "MyString",
      :hub_id => 1
    ))
  end

  it "renders the edit feed form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", feed_path(@feed), "post" do
      assert_select "input#feed_url[name=?]", "feed[url]"
      assert_select "input#feed_hub_id[name=?]", "feed[hub_id]"
    end
  end
end
