require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  
  context "routing" do
    should "map show" do
      assert_routing({:path => '/users/abc'},
        {:controller => "users", :action => "show", :id => 'abc'})
    end
    should "map new" do
      assert_routing({:path => '/users/new'},
        {:controller => "users", :action => "new"})
    end
    should "map edit" do
      assert_routing({:path => '/users/abc/edit'},
        {:controller => "users", :action => "edit", :id => 'abc'})
    end
    should "map update" do
      assert_routing({:method => 'put', :path => '/users/abc'},
        {:controller => "users", :action => "update", :id => 'abc'})
    end
    should "map activate/:activation_code" do
      assert_routing({:path => '/activate/dude_code'},
        {:controller => "users", :action => "activate", :activation_code => 'dude_code'})
    end
    should "map recover_password" do
      assert_routing({:path => '/users/recover_password'},
        {:controller => "users", :action => "recover_password"})
    end 
  end

  context "access control" do
    should "require login" do
      [:show,:edit,:update].each do |action|
        get action
        assert_redirected_to new_session_path
      end
    end
  end
  
  context "request to show" do
    setup do
      @user = create_user
    end
    should "be a success" do
      login_me(@user)
      User.stubs(:find_by_url_slug).returns(@user)
      get :show, :id => @user.to_param
      assert_response :success
    end
    should "load the requested user" do
      login_me(@user)
      User.expects(:find_by_url_slug).with(@user.to_param).returns(@user)
      get :show, :id => @user.to_param
    end
  end
  
  context 'requests to new' do
    should "be successfull" do
      get :new
      assert_response :success
      assert_template 'new'
    end
  end
  
  context 'requests to create' do
    setup do
      @user_params = { "login" => 'quire', "email" => 'quire@example.com',
          "password" => 'quire', "password_confirmation" => 'quire' }
      @user = create_user
    end
    should "create a new user" do
      User.expects(:new).with(@user_params).returns(@user)
      @user.expects(:save!)
      post :create, :user => @user_params
      assert_redirected_to root_url
    end
    should "not log in the user" do
      User.expects(:new).with(@user_params).returns(@user)
      @user.expects(:save!)
      post :create, :user => @user_params
      assert !@controller.send(:logged_in?)
    end
    should "re-render new template on failure" do
      @user_params.merge!("password_confirmation" => nil)
      post :create, :user => @user_params
      assert_template 'new'
    end
  end
  
  context "requests to create an invited user" do
    should "check invitation" do
      inviter = create_user(:login => 'inviter')
      @request.session[:inviter] = 'inviter'
  
      post :create, :user => valid_user_options(:login => 'invited')
  
      invited = User.find_by_login('invited')
      assert_not_nil invited
      assert_equal inviter.id, invited.inviter_id
    end
  end
  
  context 'requests to activate' do
    should "activate the requested user" do
      user = create_user(:login => 'aaron', :password => 'test', :password_confirmation => 'test')
      user.activation_code = 'abc'
      assert !user.active?
      user.expects(:activate)
      User.stubs(:find_by_activation_code).returns(user)
      
      get :activate, :activation_code => user.activation_code
      
      assert_redirected_to edit_user_path(user)
    end
    should "reset password on recover" do
      user = create_user
      user.expects(:reset_activation)
      user.stubs(:activation_code).returns('foobar')
      user.stubs(:activated_at).returns(nil)
      user.stubs(:email).returns("foo@bar.com")
      user.stubs(:login).returns("foobar")
      User.expects(:find_by_email).with('foo@bar.com').returns(user)
      
      post :recover_password, :email => 'foo@bar.com'
      
      assert_template('users/password_recovered')
    end
  end
  
  context "requests to edit" do
    setup do
      @user = create_user
      login_me(@user)
      get :edit
    end
  
    should "be a success and load the current user" do
      assert_response :success
      assert_equal @user.id, assigns(:user).id
    end
  end
  
  context 'requests to update' do
    setup do
      @user = create_user
      login_me(@user)
    end
    should "update the requested user attributes" do
      @user.expects(:update_attributes).with("website" => 'new_website').returns(true)
      put :update, :user => {"website" => 'new_website'}
      assert_redirected_to user_path(@user)
    end
  end
  
end
