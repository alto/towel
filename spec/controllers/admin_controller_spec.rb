require File.dirname(__FILE__) + '/../spec_helper'

describe AdminController, "routing" do
  it "should map index" do
    route_for(:controller => "admin", :action => "index").should == "/admin"
  end
end

describe AdminController, "access control" do
  it "should require an admin" do
    [:index].each do |action|
      get action
      response.should redirect_to(new_session_path)
    end
  end
end
