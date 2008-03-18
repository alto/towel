require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/show" do
  before do
    assigns[:project] = mock_project
    assigns[:cards] = [mock_card]
    assigns[:days] = [mock_day]
    stub!(:ziya_chart).and_return('ziya_chart')
  end
  it "should render" do
    render '/projects/show'
  end
  it "should display a finish button" do
    render '/projects/show'
    response.should have_tag('input[value=finish]')
  end
  it "should display a start button" do
    render '/projects/show'
    response.should have_tag('input[value=start]')
  end
end
