require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController, "routing" do
  it "should map index" do
    route_for(:controller => "admin/users", :action => "index").should == "/admin/users"
  end
  it "should map destroy" do
    route_for(:controller => "admin/users", :action => "destroy", :id => '1').should == "/admin/users/1"
  end
  it "should map undelete" do
    route_for(:controller => "admin/users", :action => "undelete", :id => '1').should == "/admin/users/1/undelete"
  end
end

describe Admin::UsersController, "access control" do
  it "should require an admin" do
    [:index,:destroy,:undelete].each do |action|
      get action
      response.should redirect_to(new_session_path)
    end
  end
end

describe Admin::UsersController, 'request to destroy' do
  before do
    login_me(mock_admin)
    @user = mock_user
    User.stub!(:find_by_url_slug).and_return(@user)
  end
  it "should delete the requested user" do
    User.should_receive(:find_by_url_slug).with(@user.to_param).and_return(@user)
    @user.should_receive(:delete!)
    get :destroy, :id => @user.to_param
    response.should redirect_to(admin_users_path)
  end
  it "should notify the user about it" do
    comment = 'you are dumb'
    StatusMailer.should_receive(:deliver_user_deleted).with(@user, comment)
    get :destroy, :id => @user.to_param, :comment => comment
  end
end

describe Admin::UsersController, 'request to undelete' do
  before do
    login_me(mock_admin)
    @user = mock_user
    User.stub!(:find_by_url_slug).and_return(@user)
  end
  it "should undelete the requested event" do
    User.should_receive(:find_by_url_slug).with(@user.to_param).and_return(@user)
    @user.should_receive(:undelete!)
    get :undelete, :id => @user.to_param
    response.should redirect_to(admin_users_path)
  end
  it "should notify the user about it" do
    comment = 'you are dumb'
    StatusMailer.should_receive(:deliver_user_undeleted).with(@user, comment)
    get :undelete, :id => @user.to_param, :comment => comment
  end
end

