require File.dirname(__FILE__) + '/../spec_helper'

describe CardsController, 'routing' do
  it "should map show" do
    route_for(:controller => "cards", :action => "show", :project_id => 'abc', :id => '1').should == "/projects/abc/cards/1"
  end
  it "should map new" do
    route_for(:controller => "cards", :action => "new", :project_id => 'abc').should == "/projects/abc/cards/new"
  end
  it "should map create" do
    route_for(:controller => "cards", :action => "create", :project_id => 'abc').should == "/projects/abc/cards"
  end
  it "should map edit" do
    route_for(:controller => "cards", :action => "edit", :project_id => 'abc', :id => '1').should == "/projects/abc/cards/1/edit"
  end
  it "should map update" do
    route_for(:controller => "cards", :action => "update", :project_id => 'abc', :id => '1').should == "/projects/abc/cards/1"
  end
  it "should map destroy" do
    route_for(:controller => "cards", :action => "destroy", :project_id => 'abc', :id => '1').should == "/projects/abc/cards/1"
  end
end

describe CardsController, "access control" do
  it "should require login" do
    [:show,:new,:create,:edit,:update,:destroy].each do |action|
      get action
      response.should redirect_to(new_session_path)
    end
  end
end

describe CardsController, "request to show" do
  before do
    @project = create_project
    @card = create_card(:project => @project)
    login_me(@project.user)
  end
  def request_show
    get :show, :project_id => @project.to_param, :id => @card.to_param
  end
  it "should be a success" do
    request_show
    response.should be_success
    response.should render_template('show')
  end
  it "should load the requested project and card" do
    request_show
    assigns(:project).id.should eql(@project.id)
    assigns(:card).id.should eql(@card.id)
  end
end

describe CardsController, "request to new" do
  before do
    @project = create_project
    login_me(mock_user)
  end
  it "should be successfull" do
    get :new, :project_id => @project.to_param
    response.should render_template('new')
    assigns(:card).should be_new_record
  end
end

describe CardsController, "request to create" do
  before do
    @project = create_project
    login_me(@project.user)
  end
  it "should be successfull" do
    post :create, :project_id => @project.to_param, :card => valid_card_fields
    card = assigns(:card)
    response.should redirect_to(project_card_path(@project, card))
    card.should_not be_new_record
    card.project_id.should eql(@project.id)
  end
  it "should fail" do
    post :create, :project_id => @project.to_param, :project => valid_project_fields.merge(:title => nil)
    response.should render_template('new')
    card = assigns(:card)
    card.should be_new_record
  end
end

describe CardsController, "request to edit" do
  before do
    @project = create_project
    @card = create_card(:project => @project)
    login_me(@project.user)
  end
  def request_edit
    get :edit, :project_id => @project.to_param, :id => @card.to_param
  end
  it "should be a success" do
    request_edit
    response.should be_success
    response.should render_template('edit')
  end
  it "should load the requested project and card" do
    request_edit
    assigns(:project).id.should eql(@project.id)
    assigns(:card).id.should eql(@card.id)
  end
end

describe CardsController, "request to update" do
  before do
    @project = create_project
    @card = create_card(:project => @project)
    login_me(@project.user)
  end
  def request_update(card_params)
    put :update, :project_id => @project.to_param, :id => @card.to_param, :card => card_params
  end
  it "should be a success" do
    request_update(valid_card_fields)
    response.should redirect_to(project_card_path(@project, @card))
  end
  it "should load the requested project and card" do
    request_update(valid_card_fields)
    assigns(:project).id.should eql(@project.id)
    assigns(:card).id.should eql(@card.id)
  end
  it "should fail" do
    request_update(valid_card_fields.merge(:title => nil))
    @card.reload.title.should_not be_nil
    response.should render_template('edit')
  end
end

describe CardsController, "request to destroy" do
  before do
    @project = create_project
    @card = create_card(:project => @project)
    login_me(@project.user)
  end
  it "should be successfull" do
    post :destroy, :project_id => @project.to_param, :id => @card.to_param
    response.should redirect_to(project_path(@project))
    Card.find_by_id(@card.id).should be_nil
  end
end
