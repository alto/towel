require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase

  context "routing" do
    should "map index" do
      assert_routing('/',
        {:controller => 'home', :action => 'index'})
    end
    should "map static pages" do
      %w(imprint terms_of_service contact deleted_record).each do |page|
        assert_routing("/#{page}",
          {:controller => 'home', :action => page})
      end
    end
  end

  context "request to index with inviter" do
    setup do
      @inviter = create_user(:login => 'inviter')
    end
    should "keep the inviter in mind" do
      get :index, :inviter => @inviter.login
      assert_equal 'inviter', session[:inviter]
    end
    should "redirect to index page without inviter" do
      get :index, :inviter => @inviter.login
      assert_redirected_to root_url
    end
  end
  
  context 'contact get request' do
    should 'be successfull' do
      get :contact
      assert_response :success
    end
  end
  
  context 'contact post request' do
    should "send a contact mail (on valid data)" do
      SystemMailer.expects(:deliver_contact)
      post :contact, :subject => 'subject', :body => 'body', :email => 'sender@test.com', :name => 'name'
      assert_redirected_to root_url
    end
    should "re-display contact form (on missing subject)" do
      SystemMailer.expects(:deliver_contact).never
      post :contact, :subject => nil, :body => 'body', :email => 'sender@test.com', :name => 'name'
      assert_template 'contact'
    end
    should 're-display contact form (on missing body)' do
      SystemMailer.expects(:deliver_contact).never
      post :contact, :subject => 'subject', :body => nil, :email => 'sender@test.com', :name => 'name'
      assert_template 'contact'
    end
    should 're-display contact form (on missing name)' do
      SystemMailer.expects(:deliver_contact).never
      post :contact, :subject => 'subject', :body => 'body', :email => 'sender@test.com', :name => nil
      assert_template 'contact'
    end
    should 're-display contact form (on missing email)' do
      SystemMailer.expects(:deliver_contact).never
      post :contact, :subject => 'subject', :body => 'body', :email => nil, :name => 'name'
      assert_template 'contact'
    end
    should "re-display contact form (on invalid email)" do
      post :contact, :subject => 'subject', :body => 'body', :email => 'email', :name => 'name'
      assert_template 'contact'
    end
  end
  
  context 'request to deleted_record' do
    should "indicate unavailable data" do
      get :deleted_record
      assert_response :not_found
    end
  end

end
