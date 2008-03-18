require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  
  include AuthenticatedTestHelper

  it "should login and redirect" do
    user = mock_user(:login => 'quentin', :password => 'test', :password_confirmation => 'test')
    User.should_receive(:authenticate).with('quentin', 'test').and_return(user)
    post :create, :login => 'quentin', :password => 'test'
    session[:user_id].should_not be_nil
    response.should be_redirect    
  end
  
  it "should fail login and not redirect with bad password" do
    user = mock_user(:login => 'quentin', :password => 'test', :password_confirmation => 'test')
    User.should_receive(:authenticate).with('quentin', 'bad password').and_return(nil)
    post :create, :login => 'quentin', :password => 'bad password'
    session[:user].should be_nil
    response.should be_success
  end
  
  it "should logout on destroy" do
    login_me(create_user)
    session[:user].should_not be_nil
    get :destroy
    session[:user].should be_nil
    response.should be_redirect
  end
  
  it "should remember me" do
    user = mock_user
    user.should_receive(:remember_me)
    user.should_receive(:remember_token).and_return('jaja')
    user.should_receive(:remember_token_expires_at).and_return(2.days.from_now)
    User.should_receive(:authenticate).with('quentin', 'test').and_return(user)
    post :create, :login => 'quentin', :password => 'test', :remember_me => "1"
    cookies["auth_token"].should_not be_nil
  end
    
  it "should not remember me" do
    user = mock_user
    User.should_receive(:authenticate).with('quentin', 'test').and_return(user)
    post :create, :login => 'quentin', :password => 'test', :remember_me => "0"
    cookies[:auth_token].should be_nil
  end

  it "should delete token on logout" do
    login_me(user = mock_user)
    user.should_receive(:forget_me)
    request.cookies['auth_token'] = CGI::Cookie.new('auth_token', "jaja")
    get :destroy
    cookies[:auth_token].should be_nil
  end

  it "should login from cookie" do
    user = mock_user
    user.should_receive(:remember_token?).and_return(true)
    user.should_receive(:remember_token).and_return('jaja')
    user.should_receive(:remember_token_expires_at).and_return(2.days.from_now)
    user.should_receive(:remember_me)
    User.should_receive(:find_by_remember_token).with("jaja").and_return(user)
    request.cookies['auth_token'] = CGI::Cookie.new('auth_token', "jaja")
    request.cookies['auth_token'].should_not be_nil
    get :new
    controller.send(:logged_in?).should be_true    
  end

  it "should fail expired cookie login" do
    user = mock_user
    user.should_receive(:remember_token?).and_return(false)
    User.should_receive(:find_by_remember_token).with("jaja").and_return(user)

    request.cookies['auth_token'] = CGI::Cookie.new('auth_token', "jaja")
    get :new
    controller.send(:logged_in?).should_not be_true
  end
end

describe SessionsController, "ajax login" do
  before do
    @password = 'password'
    @user = create_user(:password => @password, :password_confirmation => @password)
  end
  it "should log the requested user in" do
    xhr :post, :create, :login => @user.login, :password => @password
    session[:user_id].should_not be_nil
  end
  it "should ignore wrong logins" do
    xhr :post, :create, :login => @user.login, :password => 'wrong_password'
    response.response_code.should eql(204)
  end
end
