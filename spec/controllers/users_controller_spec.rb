require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, "routing" do
  it "should map show" do
    route_for(:controller => "users", :action => "show", :id => 'abc').should == "/users/abc"
  end
  it "should map new" do
    route_for(:controller => "users", :action => "new").should == "/users/new"
  end
  it "should map edit" do
    route_for(:controller => "users", :action => "edit", :id => 'abc').should == "/users/abc/edit"
  end
  it "should map update" do
    route_for(:controller => "users", :action => "update", :id => 'abc').should == "/users/abc"
  end
  it "should map activate/:activation_code" do
    route_for(:controller => "users", :action => 'activate', :activation_code => 'dude_code').should == "/activate/dude_code"
  end
  it "should map recover_password" do
    route_for(:controller => "users", :action => 'recover_password').should == "/users/recover_password"
  end 
end

describe UsersController, "access control" do
  it "should require login" do
    [:show,:edit,:update].each do |action|
      get action
      response.should redirect_to(new_session_path)
    end
  end
end

describe UsersController, "request to show" do
  before do
    @user = mock_user
  end
  def request_show
    get :show, :id => @user.to_param
  end
  it "should be a success" do
    login_me(@user)
    User.stub!(:find_by_url_slug).and_return(@user)
    request_show
    response.should be_success
  end
  it "should load the requested user" do
    login_me(@user)
    User.should_receive(:find_by_url_slug).with(@user.to_param).and_return(@user)
    request_show
  end
end

describe UsersController, 'requests to new' do
  it "should be successfull" do
    get :new
    response.should be_success
    response.should render_template('new')
  end
end

describe UsersController, 'requests to create' do
  before do
    @user_params = { "login" => 'quire', "email" => 'quire@example.com',
        "password" => 'quire', "password_confirmation" => 'quire' }
    @user = mock_user
  end
  it "should create a new user" do
    User.should_receive(:new).with(@user_params).and_return(@user)
    @user.should_receive(:save!).and_return(true)
    post :create, :user => @user_params
    response.should redirect_to('/')
  end
  it "should not log in the user" do
    User.should_receive(:new).with(@user_params).and_return(@user)
    @user.should_receive(:save!).and_return(true)
    post :create, :user => @user_params
    controller.send(:logged_in?).should be_false
  end
  it "should re-render new template on failure" do
    @user_params.merge!("password_confirmation" => nil)
    post :create, :user => @user_params
    response.should render_template('new')
  end
end

describe UsersController, "requests to create an invted user" do
  it "should check invitation" do
    inviter = create_user(:login => 'inviter')
    controller.session[:inviter] = 'inviter'
    
    post :create, :user => valid_user_fields('invited')
    
    invited = User.find_by_login('invited')
    invited.should_not be_nil
    invited.inviter_id.should eql(inviter.id)
  end
end

describe UsersController, 'requests to activate' do
  before do
    # @deliveries = ActionMailer::Base.deliveries
    # @deliveries.clear
  end

  it "should activate the requested user" do
    stub_logged_in(true)
    user = mock_user(:login => 'aaron', :password => 'test', :password_confirmation => 'test', 
      :activated? => false, :activation_code => 'abc')
    user.stub!(:active?).and_return(false)
    user.should_receive(:activate)
    User.stub!(:find_by_activation_code).and_return(user)
    get :activate, :activation_code => user.activation_code
    response.should redirect_to(edit_user_path(user))
  end
  it "should reset password on recover" do
    user = mock_user
    user.should_receive(:reset_activation)
    user.stub!(:activation_code).and_return('foobar')
    user.stub!(:activated_at).and_return(nil)
    user.stub!(:email).and_return("foo@bar.com")
    user.stub!(:login).and_return("foobar")
    User.should_receive(:find_by_email).with('foo@bar.com').and_return(user)
    post :recover_password, :email => 'foo@bar.com'
    response.should be_success
    response.should render_template('users/password_recovered')
    @deliveries.should_not be_empty
  end
end

describe UsersController, "requests to edit" do
  before do
    @user = mock_user
    login_me(@user)
    get :edit
  end
  
  it "should be a success" do
    response.should be_success
  end
  it "should load the current user" do
    assigns(:user).id.should eql(@user.id)
  end
end

describe UsersController, 'requests to update' do
  before do
    @user = mock_user
    login_me(@user)
  end
  it "should update the requested user attributes" do
    @user.should_receive(:update_attributes).with("website" => 'new_website').and_return(true)
    put :update, :user => {"website" => 'new_website'}
    response.should redirect_to(user_path(@user))
  end
end
