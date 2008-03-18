require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController, "routing" do
  it "should map index" do
    route_for(:controller => "home", :action => "index").should == "/"
  end
  it "should map imprint" do
    route_for(:controller => "home", :action => "imprint").should == "/imprint"
  end
  it "should map terms_of_service" do
    route_for(:controller => "home", :action => "terms_of_service").should == "/terms_of_service"
  end
  it "should map contact" do
    route_for(:controller => "home", :action => "contact").should == "/contact"
  end
  it "should map deleted record" do
    route_for(:controller => "home", :action => "deleted_record").should == "/deleted_record"
  end
end

describe HomeController, "request to index" do
  before do
  end
end

describe HomeController, "request to index with inviter" do
  before do
    @inviter = mock_user(:login => 'inviter')
  end
  it "should keep the inviter in mind" do
    get :index, :inviter => @inviter.login
    session[:inviter].should eql('inviter')
  end
  it "should redirect to index page without inviter" do
    get :index, :inviter => @inviter.login
    response.should redirect_to(root_url)
  end
end

describe HomeController, 'contact get request' do
  it 'should be successfull' do
    get :contact
    response.should be_success
  end
end

describe HomeController, 'contact post request' do
  it "should send a contact mail (on valid data)" do
    SystemMailer.should_receive(:deliver_contact)
    post :contact, :subject => 'subject', :body => 'body', :email => 'sender@test.com', :name => 'name'
    response.should be_redirect
    response.should redirect_to(:action => 'index')
  end
  it "should re-display contact form (on missing subject)" do
    SystemMailer.should_not_receive(:deliver_contact)
    post :contact, :subject => nil, :body => 'body', :email => 'sender@test.com', :name => 'name'
    response.should render_template('contact')
  end
  it 'should re-display contact form (on missing body)' do
    SystemMailer.should_not_receive(:deliver_contact)
    post :contact, :subject => 'subject', :body => nil, :email => 'sender@test.com', :name => 'name'
    response.should render_template('contact')
  end
  it 'should re-display contact form (on missing name)' do
    SystemMailer.should_not_receive(:deliver_contact)
    post :contact, :subject => 'subject', :body => 'body', :email => 'sender@test.com', :name => nil
    response.should render_template('contact')
  end
  it 'should re-display contact form (on missing email)' do
    SystemMailer.should_not_receive(:deliver_contact)
    post :contact, :subject => 'subject', :body => 'body', :email => nil, :name => 'name'
    response.should render_template('contact')
  end
  it "should re-display contact form (on invalid email)" do
    post :contact, :subject => 'subject', :body => 'body', :email => 'email', :name => 'name'
    response.should render_template('contact')
  end
end

describe HomeController, 'request to deleted_record' do
  it "should indicate unavailable data" do
    get :deleted_record
    response.response_code.should eql(404)
  end
end

