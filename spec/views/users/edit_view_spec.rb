require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/edit as user" do
  before do
    render "/users/edit"
  end

  it "should display a form" do
   response.should have_tag('form')
  end
  it "should edit a user" do
    response.should have_text(/Mitglied/)
  end
end
