require 'spec_helper'

describe "posts/edit" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :url => "MyString",
      :feed_id => 1,
      :site_id => 1
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", post_path(@post), "post" do
      assert_select "input#post_url[name=?]", "post[url]"
      assert_select "input#post_feed_id[name=?]", "post[feed_id]"
      assert_select "input#post_site_id[name=?]", "post[site_id]"
    end
  end
end
