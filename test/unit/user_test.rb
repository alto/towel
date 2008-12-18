require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  context "A valid user" do
    setup do
      @user = User.new
      @user.valid?
    end
    
    should "require some fields" do
      %w(login email password password_confirmation).each do |field|
        assert @user.errors.on(field)
      end
    end
  end
  
  context "Authenticating a user" do
    setup do
      
    end

    should "reset password" do
      user = create_user
      new_password = 'new_password'
      user.update_attributes(:password => new_password, :password_confirmation => new_password)
      assert_not_nil User.authenticate(user.login, new_password)
    end
    should "not rehash password" do
      user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
      new_login = 'new_login'
      user.update_attributes(:login => new_login)
      assert_not_nil User.authenticate(new_login, 'test_password')
    end

    should "reactivate user" do
      user = create_user(:login => 'quentin')
      user.reset_activation
      assert_nil user.reload.activated_at
      assert_not_nil user.reload.activation_code
      assert_nil User.authenticate('quentin', 'test')
    end
    should "authenticate user with login" do
      user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
      assert_not_nil User.authenticate(user.login, 'test_password')
    end
    # should "should authenticate user with email" do
    #   user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
    #   User.authenticate(user.email, 'test_password').should_not be_nil
    # end
    should "not authenticate deleted user" do
      user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
      user.delete!
      assert_nil User.authenticate(user.login, 'test_password')
    end
    should "set remember token" do
      user = create_user
      user.remember_me
      assert_not_nil user.remember_token
    end
    should "unset remember token" do
      user = create_user
      user.remember_me
      assert_not_nil user.remember_token
      user.forget_me
      assert_nil user.remember_token
    end
    should "remember me for one week" do
      user = create_user
      before = 1.week.from_now.utc
      user.remember_me_for 1.week
      after = 1.week.from_now.utc
      assert_not_nil user.remember_token
      assert_not_nil user.remember_token_expires_at
      assert user.remember_token_expires_at.between?(before, after)
    end
    should "remember me until one week" do
      user = create_user
      time = 1.week.from_now.utc
      user.remember_me_until time
      assert_not_nil user.remember_token
      assert_not_nil user.remember_token_expires_at
      assert_equal time, user.remember_token_expires_at
    end
    should "remember me default two weeks" do
      user = create_user
      before = 2.weeks.from_now.utc
      user.remember_me
      after = 2.weeks.from_now.utc
      assert_not_nil user.remember_token
      assert_not_nil user.remember_token_expires_at
      assert user.remember_token_expires_at.between?(before, after)
    end
  end
  
  context "A user in test" do
    setup do
      @user = create_user
    end
    should "be active" do
      assert_nil @user.activation_code
      assert_not_nil @user.activated_at
      assert @user.active?
    end
  end

  context "A user's displayed name" do
    should "be not applicable if user is deleted" do
      user = build_user
      user.stubs(:deleted?).returns(true)
      assert_equal 'N/A', user.display_name
    end
    should "equal his or her login name" do
      assert_equal 'login', build_user(:login => 'login').display_name
    end
  end

  context "A user's roles" do
    should "allow admin" do
      @user = build_user(:role => nil)
      assert !@user.admin?
      @user.role = 'user'
      assert !@user.admin?
      @user.role = 'admin'
      assert @user.admin?
    end
  end

  context "Editing a user" do
    setup do
      @user = create_user
    end
    should "be granted to user himself" do
      assert @user.editable_by?(@user)
    end
    should "denied to others" do
      assert !@user.editable_by?(nil)
      assert !@user.editable_by?(:false)
      assert !@user.editable_by?(create_user(:login => 'other'))
    end
  end

  context "A user's states" do
    setup do
      @user = create_user
    end
    should "allow delete and undelete" do
      assert_nil @user.deleted_at
      assert !@user.deleted?
      @user.delete!
      assert_not_nil @user.deleted_at
      assert @user.deleted?
      @user.undelete!
      assert_nil @user.deleted_at
      assert !@user.deleted?
    end
  end

end
