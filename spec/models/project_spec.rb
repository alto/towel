require File.dirname(__FILE__) + '/../spec_helper'

describe Project, "validations" do
  it "should validate presence of name" do
    Project.should have_validated_presence_of(:name)
  end
  it "should validate presence of user" do
    Project.should have_validated_presence_of(:user_id)
  end
end

describe Project, "instance" do
  before do
    @project = Project.new
  end
  it "should have an owner" do
    @project.should respond_to(:user)
  end
  it "should have events" do
    @project.should respond_to(:events)
  end
end

describe Project, 'attribute protection' do
  it "should protect the owner" do
    Project.should protect_attribute(:user_id)
  end
end

describe Project, 'creation' do
  it "should create a creation event, too" do
    project = create_project
    project.reload.events.find(:all, :conditions => "event_type = 'project_created'").size.should eql(1)
  end
end

describe Project, "deletion" do
  before do
    @project = create_project
  end
  it "should delete its cards, too" do
    card = mock_card
    @project.stub!(:cards).and_return([card])
    card.should_receive(:destroy)
    @project.destroy
  end
  it "should delete its events, too" do
    event = mock_model(Event)
    @project.stub!(:events).and_return([event])
    event.should_receive(:destroy)
    @project.destroy
  end
end
