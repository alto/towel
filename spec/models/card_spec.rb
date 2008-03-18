require File.dirname(__FILE__) + '/../spec_helper'

describe Card, "validations" do
  it "should validate presence of title" do
    Card.should have_validated_presence_of(:title)
  end
  it "should validate presence of project" do
    Card.should have_validated_presence_of(:project_id)
  end
end

describe Card, "instance" do
  before do
    @card = Card.new
  end
  it "should have a project" do
    @card.should respond_to(:project)
  end
  it "should have events" do
    @card.should respond_to(:events)
  end
end

describe Card, 'attribute protection' do
  it "should protect the project" do
    Card.should protect_attribute(:project_id)
  end
end

describe Card, 'creation' do
  it "should create a creation event, too" do
    card = create_card
    card.reload.events.find(:all, :conditions => "event_type = 'card_created'").size.should eql(1)
  end
  it "should create an estimation event, too" do
    card = create_card(:effort => 13)
    events = card.reload.events.find(:all, :conditions => "event_type = 'card_estimated'")
    events.size.should eql(1)
    events.first.from.should be_nil
    events.first.to.should eql('13')
  end
end

describe Card, 'starting' do
  it "should create a start event, too" do
    timestamp = Time.now
    card = create_card
    card.update_attribute(:started_at, timestamp)
    events = card.reload.events.find(:all, :conditions => "event_type = 'card_started'")
    events.size.should eql(1)
    events.first.created_at.same_time_as?(timestamp).should be_true
  end
end

describe Card, 'finishing' do
  it "should create a finish event, too" do
    timestamp = Time.now
    card = create_card
    card.update_attribute(:finished_at, timestamp)
    events = card.reload.events.find(:all, :conditions => "event_type = 'card_finished'")
    events.size.should eql(1)
    events.first.created_at.same_time_as?(timestamp).should be_true
  end
end

describe Card, 'events' do
  before do
    @card = create_card
  end
  it "should belong to the card's project" do
    @card.events.each {|e| e.project_id.should eql(@card.project_id)}
  end
end

describe Card, 'state' do
  it "should be added" do
    card = Card.new
    card.display_state.should eql('added')
    card.should_not be_started
    card.should_not be_finished
  end
  it "should be estimated" do
    card = Card.new(:effort => 2)
    card.display_state.should eql('estimated')
    card.should_not be_started
    card.should_not be_finished
  end
  it "should be started" do
    card = Card.new(:started_at => Time.now)
    card.display_state.should eql('started')
    card.should be_started
    card.should_not be_finished
  end
  it "should be finished" do
    card = Card.new(:finished_at => Time.now)
    card.display_state.should eql('finished')
    card.should_not be_started
    card.should be_finished
  end
  it "should be started and then finished" do
    card = Card.new(:started_at => Time.now, :finished_at => Time.now)
    card.display_state.should eql('finished')
    card.should_not be_started
    card.should be_finished
  end
end
