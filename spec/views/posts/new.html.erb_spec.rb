require 'spec_helper'

describe "posts/new" do
  before(:each) do
    assign(:post, stub_model(Post,
      :url => "MyString",
      :feed_id => 1,
      :site_id => 1
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", posts_path, "post" do
      assert_select "input#post_url[name=?]", "post[url]"
      assert_select "input#post_feed_id[name=?]", "post[feed_id]"
      assert_select "input#post_site_id[name=?]", "post[site_id]"
    end
  end
end
