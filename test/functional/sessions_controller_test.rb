require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  include AuthenticatedTestHelper

  context "authentication" do

    should "login and redirect" do
      user = create_user(:login => 'quentin', :password => 'test', :password_confirmation => 'test')
      User.expects(:authenticate).with('quentin', 'test').returns(user)
      post :create, :login => 'quentin', :password => 'test'
      assert_not_nil session[:user_id]
      assert_response :redirect
    end

    should "fail login and not redirect with bad password" do
      user = create_user(:login => 'quentin', :password => 'test', :password_confirmation => 'test')
      User.expects(:authenticate).with('quentin', 'bad password').returns(nil)
      post :create, :login => 'quentin', :password => 'bad password'
      assert_nil session[:user]
      assert_response :success
    end

    should "logout on destroy" do
      login_me(create_user)
      assert_not_nil @request.session[:user]
      get :destroy
      assert_nil @request.session[:user]
      assert_response :redirect
    end

    should "remember me" do
      user = create_user
      user.expects(:remember_me)
      user.expects(:remember_token).returns('jaja')
      user.expects(:remember_token_expires_at).returns(2.days.from_now)
      User.expects(:authenticate).with('quentin', 'test').returns(user)
      post :create, :login => 'quentin', :password => 'test', :remember_me => "1"
      assert_not_nil cookies["auth_token"]
    end

    should "not remember me" do
      user = create_user
      User.expects(:authenticate).with('quentin', 'test').returns(user)
      post :create, :login => 'quentin', :password => 'test', :remember_me => "0"
      assert_nil cookies[:auth_token]
    end

    should "delete token on logout" do
      login_me(user = create_user)
      user.expects(:forget_me)
      @request.cookies['auth_token'] = CGI::Cookie.new('auth_token', "jaja")
      get :destroy
      assert_nil cookies[:auth_token]
    end

    should "login from cookie" do
      user = create_user
      user.expects(:remember_token?).returns(true)
      user.expects(:remember_token).returns('jaja')
      user.expects(:remember_token_expires_at).returns(2.days.from_now)
      user.expects(:remember_me)
      User.expects(:find_by_remember_token).with("jaja").returns(user)
      @request.cookies['auth_token'] = CGI::Cookie.new('auth_token', "jaja")
      assert_not_nil @request.cookies['auth_token']
      get :new
      assert @controller.send(:logged_in?)
    end

    should "fail for expired cookie login" do
      user = create_user
      user.expects(:remember_token?).returns(false)
      User.expects(:find_by_remember_token).with("jaja").returns(user)

      @request.cookies['auth_token'] = CGI::Cookie.new('auth_token', "jaja")
      get :new
      assert !@controller.send(:logged_in?)
    end
  end

  context "ajax login" do
    setup do
      @password = 'password'
      @user = create_user(:password => @password, :password_confirmation => @password)
    end
    should "log the requested user in" do
      xhr :post, :create, :login => @user.login, :password => @password
      assert_not_nil session[:user_id]
    end
    should "ignore wrong logins" do
      xhr :post, :create, :login => @user.login, :password => 'wrong_password'
      assert_response 204
    end
  end

end
