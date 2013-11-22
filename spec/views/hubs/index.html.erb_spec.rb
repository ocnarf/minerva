require 'spec_helper'

describe "hubs/index" do
  before(:each) do
    assign(:hubs, [
      stub_model(Hub,
        :url => "Url"
      ),
      stub_model(Hub,
        :url => "Url"
      )
    ])
  end

  it "renders a list of hubs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
