require File.dirname(__FILE__) + '/../spec_helper'

describe Event, "validations" do
  it "should validate presence of type" do
    Event.should have_validated_presence_of(:event_type)
  end
  it "should validate presence of project" do
    Event.should have_validated_presence_of(:project_id)
  end
end

describe Event, "instance" do
  before do
    @event = Event.new
  end
  it "should have a project" do
    @event.should respond_to(:project)
  end
  it "should have a card" do
    @event.should respond_to(:card)
  end
end

describe Event, 'project_created' do
  it "should succeed" do
    lambda {
      Event.project_created(mock_project)
    }.should change(Event, :count).from(0).to(1)
  end
  it "should fail" do
    lambda {
      Event.project_created(nil)
    }.should_not change(Event, :count)
  end
end

describe Event, 'card_created' do
  it "should succeed" do
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(1)
      Event.card_created(card)
    }.should change(Event, :count).from(0).to(1)
  end
  it "should fail" do
    lambda {
      Event.card_created(nil)
    }.should_not change(Event, :count)
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(nil)
      Event.card_created(card)
    }.should_not change(Event, :count)
  end
end

describe Event, 'card_estimated' do
  it "should succeed" do
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(1)
      Event.card_estimated(card, nil, '2')
    }.should change(Event, :count).from(0).to(1)
  end
  it "should fail" do
    lambda {
      Event.card_estimated(nil, nil, '2')
    }.should_not change(Event, :count)
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(nil)
      Event.card_estimated(card, nil, '2')
    }.should_not change(Event, :count)
  end
end

describe Event, 'card_started' do
  it "should succeed" do
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(1)
      Event.card_started(card)
    }.should change(Event, :count).from(0).to(1)
  end
  it "should fail" do
    lambda {
      Event.card_started(nil)
    }.should_not change(Event, :count)
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(nil)
      Event.card_started(card)
    }.should_not change(Event, :count)
  end
end

describe Event, 'card_finished' do
  it "should succeed" do
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(1)
      Event.card_finished(card)
    }.should change(Event, :count).from(0).to(1)
  end
  it "should fail" do
    lambda {
      Event.card_finished(nil)
    }.should_not change(Event, :count)
    lambda {
      card = mock_card
      card.stub!(:project_id).and_return(nil)
      Event.card_finished(card)
    }.should_not change(Event, :count)
  end
end

