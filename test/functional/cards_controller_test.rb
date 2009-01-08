require File.dirname(__FILE__) + '/../test_helper'

class CardsControllerTest < ActionController::TestCase

  context 'routing' do
    should "map show" do
      assert_routing({:path => '/projects/abc/cards/1'},
        {:controller => "cards", :action => "show", :project_id => 'abc', :id => '1'})
    end
    should "map new" do
      assert_routing('/projects/abc/cards/new',
        {:controller => "cards", :action => "new", :project_id => 'abc'})
    end
    should "map create" do
      assert_routing({:method => "post", :path => '/projects/abc/cards'},
        {:controller => "cards", :action => "create", :project_id => 'abc'})
    end
    should "map edit" do
      assert_routing('/projects/abc/cards/1/edit',
        {:controller => "cards", :action => "edit", :project_id => 'abc', :id => '1'})
    end
    should "map update" do
      assert_routing({:method => 'put', :path => '/projects/abc/cards/1'},
        {:controller => "cards", :action => "update", :project_id => 'abc', :id => '1'})
    end
    should "map destroy" do
      assert_routing({:method => 'delete', :path => '/projects/abc/cards/1'},
        {:controller => "cards", :action => "destroy", :project_id => 'abc', :id => '1'})
    end
  end

  context "access control" do
    should "require login" do
      [:show,:new,:create,:edit,:update,:destroy].each do |action|
        get action
        assert_redirected_to new_session_path
      end
    end
  end
  
  context "request to show" do
    setup do
      @project = create_project
      @card = create_card(:project => @project)
      login_me(@project.user)
    end
    should "be a success" do
      get :show, :project_id => @project.to_param, :id => @card.to_param
      assert_template 'show'
    end
    should "load the requested project and card" do
      get :show, :project_id => @project.to_param, :id => @card.to_param
      assert_equal @project.id, assigns(:project).id
      assert_equal @card.id, assigns(:card).id
    end
  end
  
  context "request to new" do
    setup do
      @project = create_project
      login_me(@project.user)
    end
    should "be successfull" do
      get :new, :project_id => @project.to_param
      assert_template 'new'
      assert assigns(:card).new_record?
    end
  end
  
  context "request to create" do
    setup do
      @project = create_project
      login_me(@project.user)
    end
    should "succeed" do
      post :create, :project_id => @project.to_param, :card => valid_card_options(:project => nil)
      card = assigns(:card)
      assert_redirected_to project_card_path(@project, card)
      assert !card.new_record?
      assert_equal @project.id, card.project_id
    end
    should "fail" do
      post :create, :project_id => @project.to_param, :project => {:title => nil}
      assert_template 'new'
      card = assigns(:card)
      assert card.new_record?
    end
  end
  
  context "request to edit" do
    setup do
      @project = create_project
      @card = create_card(:project => @project)
      login_me(@project.user)
    end
    should "be a success" do
      get :edit, :project_id => @project.to_param, :id => @card.to_param
      assert_template 'edit'
    end
    should "load the requested project and card" do
      get :edit, :project_id => @project.to_param, :id => @card.to_param
      assert_equal @project.id, assigns(:project).id
      assert_equal @card.id, assigns(:card).id
    end
  end
  
  def request_update(card_params)
    put :update, :project_id => @project.to_param, :id => @card.to_param, :card => card_params
  end
  context "request to update" do
    setup do
      @project = create_project
      @card = create_card(:project => @project)
      login_me(@project.user)
    end
    should "be a success" do
      request_update(:title => 'new title')
      assert_redirected_to project_card_path(@project, @card)
    end
    should "load the requested project and card" do
      request_update(:title => 'new title')
      assert_equal @project.id, assigns(:project).id
      assert_equal @card.id, assigns(:card).id
    end
    should "fail" do
      request_update(:title => nil)
      assert_not_nil @card.reload.title
      assert_template 'edit'
    end
  end
  
  context "request to destroy" do
    setup do
      @project = create_project
      @card = create_card(:project => @project)
      login_me(@project.user)
    end
    should "be successfull" do
      post :destroy, :project_id => @project.to_param, :id => @card.to_param
      assert_redirected_to project_path(@project)
      assert_nil Card.find_by_id(@card.id)
    end
  end

end
