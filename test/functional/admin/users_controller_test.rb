require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  context "routing" do
    should "map index" do
      assert_routing '/admin/users',
        {:controller => 'admin/users', :action => 'index'}
    end
    should "map destroy" do
      assert_routing({:path => '/admin/users/1', :method => 'delete'},
        {:controller => 'admin/users', :action => 'destroy', :id => '1'})
    end
    should "map undelete" do
      assert_routing({:path => '/admin/users/1/undelete', :method => 'post'},
        {:controller => 'admin/users', :action => 'undelete', :id => '1'})
    end
  end

  context "access control" do
    should "require an admin" do
      [:index,:destroy,:undelete].each do |action|
        get action
        assert_redirected_to(new_session_path)
      end
    end
  end
  
  context 'request to destroy' do
    setup do
      login_me(create_admin)
      @user = create_user
      User.stubs(:find_by_url_slug).returns(@user)
    end
    should "delete the requested user" do
      User.expects(:find_by_url_slug).with(@user.to_param).returns(@user)
      @user.expects(:delete!)
      get :destroy, :id => @user.to_param
      assert_redirected_to(admin_users_path)
    end
    should "notify the user about it" do
      comment = 'you are dumb'
      StatusMailer.expects(:deliver_user_deleted).with(@user, comment)
      get :destroy, :id => @user.to_param, :comment => comment
    end
  end
  
  context 'request to undelete' do
    setup do
      login_me(create_admin)
      @user = create_user
      User.stubs(:find_by_url_slug).returns(@user)
    end
    should "undelete the requested event" do
      User.expects(:find_by_url_slug).with(@user.to_param).returns(@user)
      @user.expects(:undelete!)
      get :undelete, :id => @user.to_param
      assert_redirected_to(admin_users_path)
    end
    should "notify the user about it" do
      comment = 'you are dumb'
      StatusMailer.expects(:deliver_user_undeleted).with(@user, comment)
      get :undelete, :id => @user.to_param, :comment => comment
    end
  end

end
