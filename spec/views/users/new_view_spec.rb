require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/new as user" do
  before do
    assigns[:user] = mock_user
    render "/users/new"
  end

  it "should display a form" do
   response.should have_tag('form')
  end
  it "should ask to create a new user" do
    response.should have_text(/Neues Mitglied/)
  end
end
