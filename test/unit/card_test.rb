require File.dirname(__FILE__) + '/../test_helper'

class CardTest < ActiveSupport::TestCase

  context "validations" do
    setup do
      @card = Card.new
      @card.valid?
    end
    should "require some fields" do
      %w(title project_id).each do |field|
        assert @card.errors.on(field)
      end
    end
  end

  context 'attribute protection' do
    should "protect the project" do
      card = Card.new(:project_id => 13)
      assert_nil card.project_id
    end
  end

  context "creating a card" do
    should "create a creation event, too" do
      card = create_card
      assert_equal 1, card.reload.events.find(:all, :conditions => "event_type = 'card_created'").length
    end
    should "create an estimation event, too" do
      card = create_card(:effort => 13)
      events = card.reload.events.find(:all, :conditions => "event_type = 'card_estimated'")
      assert_equal 1, events.length
      assert_nil events.first.from
      assert_equal '13', events.first.to
    end
  end

  context 'starting a card' do
    should "create a start event, too" do
      timestamp = Time.now
      card = create_card
      card.update_attribute(:started_at, timestamp)
      events = card.reload.events.find(:all, :conditions => "event_type = 'card_started'")
      assert_equal 1, events.length
      assert events.first.created_at.same_time_as?(timestamp)
    end
  end

  context 'finishing' do
    should "create a finish event, too" do
      timestamp = Time.now
      card = create_card
      card.update_attribute(:finished_at, timestamp)
      events = card.reload.events.find(:all, :conditions => "event_type = 'card_finished'")
      assert_equal 1, events.length
      assert events.first.created_at.same_time_as?(timestamp)
    end
  end

  context 'card events' do
    setup do
      @card = create_card
    end
    should "belong to the card's project" do
      @card.events.each {|e| assert_equal e.project_id, @card.project_id }
    end
  end

  context "a card's state" do
    should "be added" do
      card = Card.new
      assert_equal 'added', card.display_state
      assert !card.started?
      assert !card.finished?
    end
    should "be estimated" do
      card = Card.new(:effort => 2)
      assert_equal 'estimated', card.display_state
      assert !card.started?
      assert !card.finished?
    end
    should "be started, and not yet finished" do
      card = Card.new(:started_at => Time.now)
      assert_equal 'started', card.display_state
      assert card.started?
      assert !card.finished?
    end
    should "be finished" do
      card = Card.new(:finished_at => Time.now)
      assert_equal 'finished', card.display_state
      assert !card.started?
      assert card.finished?
    end
    should "be started and then finished" do
      card = Card.new(:started_at => Time.now, :finished_at => Time.now)
      assert_equal 'finished', card.display_state
      assert !card.started?
      assert card.finished?
    end
  end

end
