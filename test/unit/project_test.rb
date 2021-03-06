require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase

  context "validations" do
    setup do
      @project = Project.new
      @project.valid?
    end
    should "require some fields" do
      %w(name user_id).each do |field|
        assert @project.errors.on(field)
      end
    end
  end

  context 'attribute protection' do
    should "protect the owner" do
      project = Project.new(:user_id => 13)
      assert_nil project.user_id
    end
  end
  
  context 'creating a project' do
    should "create a creation event, too" do
      project = create_project
      assert_equal 1, project.reload.events.find(:all, :conditions => "event_type = 'project_created'").size
    end
  end
  
  context "deleting a project" do
    setup do
      @project = create_project
    end
    should "delete its cards, too" do
      card = @project.cards.create(:title => 'any title')
      assert_not_nil Card.find(card.id)
      @project.destroy
      assert_nil Card.find_by_id(card.id)
    end
    should "delete its events, too" do
      event = @project.events.create(:event_type => 'any type')
      assert_not_nil Event.find(event.id)
      @project.destroy
      assert_nil Event.find_by_id(event.id)
    end
  end

end
