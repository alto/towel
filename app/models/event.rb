# == Schema Information
# Schema version: 9
#
# Table name: events
#
#  id         :integer(11)     not null, primary key
#  project_id :integer(11)     
#  card_id    :integer(11)     
#  event_type :string(255)     
#  from       :string(255)     
#  to         :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Event < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :card
  
  validates_presence_of :project_id
  validates_presence_of :event_type

  def project_created?; event_type == 'project_created'; end
  def self.project_created(project)
    if project && project.id
      create!(:event_type => 'project_created', :project_id => project.id, 
        :created_at => project.created_at)
    end
  end
  
  def card_created?; event_type == 'card_created'; end
  def self.card_created(card)
    if card && card.id && card.project_id
      create!(:event_type => 'card_created', :project_id => card.project_id, 
        :card_id => card.id, :created_at => card.timestamp)
    end
  end
  
  def card_estimated?; event_type == 'card_estimated'; end
  def self.card_estimated(card, from, to)
    if card && card.id && card.project_id
      create!(:event_type => 'card_estimated', :project_id => card.project_id, 
        :card_id => card.id, :from => from, :to => to, :created_at => card.timestamp)
    end
  end
  
  def card_started?; event_type == 'card_started'; end
  def self.card_started(card)
    if card && card.id && card.project_id
      create!(:event_type => 'card_started', :project_id => card.project_id, 
        :card_id => card.id, :created_at => card.timestamp)
    end
  end
  
  def card_finished?; event_type == 'card_finished'; end
  def self.card_finished(card)
    if card && card.id && card.project_id
      create!(:event_type => 'card_finished', :project_id => card.project_id, 
        :card_id => card.id, :created_at => card.timestamp)
    end
  end
  
end
