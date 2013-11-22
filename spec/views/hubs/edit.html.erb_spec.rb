require 'spec_helper'

describe "hubs/edit" do
  before(:each) do
    @hub = assign(:hub, stub_model(Hub,
      :url => "MyString"
    ))
  end

  it "renders the edit hub form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hub_path(@hub), "post" do
      assert_select "input#hub_url[name=?]", "hub[url]"
    end
  end
end
