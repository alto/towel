require File.dirname(__FILE__) + '/../spec_helper'

describe User, "validations" do
  it "should validate presence of login" do
    User.should have_validated_presence_of(:login)
  end
  it "should validate presence of email" do
    User.should have_validated_presence_of(:email)
  end
  it "should validate presence of password" do
    User.should have_validated_presence_of(:password)
  end
  it "should validate presence of password_confirmation" do
    User.should have_validated_presence_of(:password_confirmation)
  end
end

describe User, "instance" do
  before do
    @user = build_user
  end
  it "should have an inviter" do
    @user.should respond_to(:inviter)
  end
  it "should have projects" do
    @user.should respond_to(:projects)
  end
end

describe User, 'authentification' do
  it "should require login" do
    user = User.new({:email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' })    
    user.should have_at_least(1).error_on(:login)
  end
  it "should require email" do
    user = User.new({:login => 'quire', :password => 'quire', :password_confirmation => 'quire' })    
    user.should have_at_least(1).error_on(:email)
  end
  it "should require password" do    
    user = User.new({:login => 'quire', :email => 'quire@example.com', :password_confirmation => 'quire' })    
    user.should have_at_least(1).error_on(:password)
  end
  it "should require password_confirmation" do    
    user = User.new({:login => 'quire', :email => 'quire@example.com', :password => 'quire' })    
    user.should have_at_least(1).error_on(:password_confirmation)
  end
  it "should reset password" do
    user = create_user
    new_password = 'new password'
    user.update_attributes(:password => new_password, :password_confirmation => new_password)
    User.authenticate(user.login, new_password).should_not be_nil
  end
  it "should not rehash password" do
    user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
    new_login = 'new_login'
    user.update_attributes(:login => new_login)
    User.authenticate(new_login, 'test_password').should_not be_nil
  end

  it "should reactivate user" do
    user = create_user(:login => 'quentin')
    user.reset_activation
    user.reload.activated_at.should be_nil
    user.reload.activation_code.should_not be_nil
    User.authenticate('quentin', 'test').should be_nil
  end
  it "should authenticate user with login" do
    user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
    User.authenticate(user.login, 'test_password').should_not be_nil
  end
  # it "should authenticate user with email" do
  #   user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
  #   User.authenticate(user.email, 'test_password').should_not be_nil
  # end
  it "should not authenticate deleted user" do
    user = create_user(:password => 'test_password', :password_confirmation => 'test_password')
    user.delete!
    User.authenticate(user.login, 'test_password').should be_nil
  end
  it "should set remember token" do
    user = create_user
    user.remember_me
    user.remember_token.should_not be_nil
  end
  it "should unset remember token" do
    user = create_user
    user.remember_me
    user.remember_token.should_not be_nil
    user.forget_me
    user.remember_token.should be_nil
  end
  it "should remember me for one week" do
    user = create_user
    before = 1.week.from_now.utc
    user.remember_me_for 1.week
    after = 1.week.from_now.utc
    user.remember_token.should_not be_nil
    user.remember_token_expires_at.should_not be_nil
    user.remember_token_expires_at.between?(before, after).should be_true
  end
  it "should remember me until one week" do
    user = create_user
    time = 1.week.from_now.utc
    user.remember_me_until time
    user.remember_token.should_not be_nil
    user.remember_token_expires_at.should_not be_nil
    user.remember_token_expires_at.should equal(time)
  end
  it "should remember me default two weeks" do
    user = create_user
    before = 2.weeks.from_now.utc
    user.remember_me
    after = 2.weeks.from_now.utc
    user.remember_token.should_not be_nil
    user.remember_token_expires_at.should_not be_nil
    user.remember_token_expires_at.between?(before, after).should be_true
  end
end

describe User, "in test" do
  before do
    @user = create_user
  end
  it "should be active" do
    @user.activation_code.should be_nil
    @user.activated_at.should_not be_nil
    @user.should be_active
  end
end

describe User, "displayed name" do
  it "should be not applicable if user is deleted" do
    user = build_user
    user.stub!(:deleted?).and_return(true)
    user.display_name.should eql('N/A')
  end
  it "should equal his or her login name" do
    build_user(:login => 'login').display_name.should eql('login')
  end
end

describe User, "roles" do
  it "should allow admin" do
    @user = build_user(:role => nil)
    @user.should_not be_admin
    @user.role = 'user'
    @user.should_not be_admin
    @user.role = 'admin'
    @user.should be_admin
  end
end

describe User, "editing" do
  before do
    @user = create_user
  end
  it "should be granted to user himself" do
    @user.editable_by?(@user).should be_true
  end
  it "should denied to others" do
    @user.editable_by?(nil).should be_false
    @user.editable_by?(:false).should be_false
    @user.editable_by?(create_user(:login => 'other')).should be_false
  end
end

describe User, 'states' do
  before do
    @user = create_user
  end
  it "should allow delete and undelete" do
    @user.deleted_at.should be_nil
    @user.should_not be_deleted
    @user.delete!
    @user.deleted_at.should_not be_nil
    @user.should be_deleted
    @user.undelete!
    @user.deleted_at.should be_nil
    @user.should_not be_deleted
  end
end
