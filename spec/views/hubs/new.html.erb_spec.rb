require 'spec_helper'

describe "hubs/new" do
  before(:each) do
    assign(:hub, stub_model(Hub,
      :url => "MyString"
    ).as_new_record)
  end

  it "renders new hub form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hubs_path, "post" do
      assert_select "input#hub_url[name=?]", "hub[url]"
    end
  end
end
