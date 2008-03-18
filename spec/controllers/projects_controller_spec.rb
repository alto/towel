require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, 'routing' do
  it "should map show" do
    route_for(:controller => "projects", :action => "show", :id => 'abc').should == "/projects/abc"
  end
  it "should map new" do
    route_for(:controller => "projects", :action => "new").should == "/projects/new"
  end
  it "should map create" do
    route_for(:controller => "projects", :action => "create").should == "/projects"
  end
end

describe ProjectsController, "access control" do
  it "should require login" do
    [:new,:create].each do |action|
      get action
      response.should redirect_to(new_session_path)
    end
  end
end

describe ProjectsController, "request to show" do
  before do
    @project = mock_project
  end
  def request_show
    get :show, :id => @project.to_param
  end
  it "should be a success" do
    Project.stub!(:find_by_url_slug).and_return(@project)
    request_show
    response.should be_success
  end
  it "should load the requested project" do
    Project.should_receive(:find_by_url_slug).with(@project.to_param).and_return(@project)
    request_show
  end
end

describe ProjectsController, "request to new" do
  before do
    login_me(mock_user)
  end
  it "should be successfull" do
    get :new
    response.should render_template('new')
    assigns(:project).should be_new_record
  end
end

describe ProjectsController, "request to create" do
  before do
    login_me(@user = create_user)
  end
  it "should be successfull" do
    post :create, :project => valid_project_fields
    project = assigns(:project)
    response.should redirect_to(project_path(project))
    project.should_not be_new_record
    project.user_id.should eql(@user.id)
  end
  it "should fail" do
    post :create, :project => valid_project_fields.merge(:name => nil)
    response.should render_template('new')
    project = assigns(:project)
    project.should be_new_record
  end
end

