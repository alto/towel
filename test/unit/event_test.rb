require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase

  context "validations" do
    setup do
      @event = Event.new
      @event.valid?
    end
    should "require some fields" do
      %w(event_type project_id).each do |field|
        assert @event.errors.on(field)
      end
    end
  end

  context 'project_created' do
    should "succeed" do
      project = create_project
      Event.delete_all
      Event.project_created(project)
      assert_equal 1, Event.count
    end
    should "fail" do
      Event.delete_all
      Event.project_created(nil)
      assert_equal 0, Event.count
    end
  end

  context 'card_created' do
    should "succeed" do
      card = create_card
      Event.delete_all
      Event.card_created(card)
      assert_equal 1, Event.count
    end
    should "fail if no card provided" do
      Event.delete_all
      Event.card_created(nil)
      assert_equal 0, Event.count
    end
    should "fail if card provided is invalid" do
      card = Card.new
      Event.delete_all
      Event.card_created(card)
      assert_equal 0, Event.count
    end
  end

  context 'card_estimated' do
    should "succeed" do
      card = create_card
      Event.delete_all
      Event.card_estimated(card, nil, '2')
      assert_equal 1, Event.count
    end
    should "fail if no card provided" do
      Event.delete_all
      Event.card_estimated(nil, nil, '2')
      assert_equal 0, Event.count
    end
    should "fail if card is invalid" do
      card = Card.new
      Event.delete_all
      Event.card_estimated(card, nil, '2')
      assert_equal 0, Event.count
    end
  end

  context 'card_started' do
    should "succeed" do
      card = create_card
      Event.delete_all
      Event.card_started(card)
      assert_equal 1, Event.count
    end
    should "fail if card is not provided" do
      Event.delete_all
      Event.card_started(nil)
      assert_equal 0, Event.count
    end
    should "fail if card is invalid" do
      card = Card.new
      Event.delete_all
      Event.card_started(card)
      assert_equal 0, Event.count
    end
  end

  context 'card_finished' do
    should "succeed" do
      card = create_card
      Event.delete_all
      Event.card_finished(card)
      assert_equal 1, Event.count
    end
    should "fail if no card provided" do
      Event.delete_all
      Event.card_finished(nil)
      assert_equal 0, Event.count
    end
    should "fail if card is invalid" do
      card = Card.new
      Event.delete_all
      Event.card_finished(card)
      assert_equal 0, Event.count
    end
  end

end
