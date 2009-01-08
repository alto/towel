require File.dirname(__FILE__) + '/../test_helper'

class ProjectsControllerTest < ActionController::TestCase

  context 'routing' do
    should "map show" do
      assert_routing({:path => '/projects/abc'},
        {:controller => "projects", :action => "show", :id => 'abc'})
    end
    should "map new" do
      assert_routing({:path => '/projects/new'},
        {:controller => "projects", :action => "new"})
    end
    should "map create" do
      assert_routing({:method => 'post', :path => '/projects'},
        {:controller => "projects", :action => "create"})
    end
  end

  context "access control" do
    should "require login" do
      [:new,:create].each do |action|
        get action
        assert_redirected_to(new_session_path)
      end
    end
  end
  
  context "request to show" do
    setup do
      @project = create_project
    end
    should "be a success" do
      Project.stubs(:find_by_url_slug).returns(@project)
      get :show, :id => @project.to_param
      assert_response :success
    end
    should "load the requested project" do
      Project.expects(:find_by_url_slug).with(@project.to_param).returns(@project)
      get :show, :id => @project.to_param
    end
  end
  
  context "request to new" do
    setup do
      login_me(create_user)
    end
    should "be successfull" do
      get :new
      assert_template('new')
      assert assigns(:project).new_record?
    end
  end
  
  context "request to create" do
    setup do
      login_me(@user = create_user)
    end
    should "be successfull" do
      post :create, :project => {:name => 'project'}
      project = assigns(:project)
      assert_redirected_to(project_path(project))
      assert !project.new_record?
      assert_equal @user.id, project.user_id
    end
    should "fail" do
      post :create, :project => {:name => nil}
      assert_template('new')
      project = assigns(:project)
      assert project.new_record?
    end
  end

end
