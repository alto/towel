# == Schema Information
# Schema version: 9
#
# Table name: cards
#
#  id          :integer(11)     not null, primary key
#  title       :string(255)     
#  description :text            
#  effort      :integer(11)     
#  project_id  :integer(11)     
#  created_at  :datetime        
#  updated_at  :datetime        
#  finished_at :datetime        
#  started_at  :datetime        
#

class Card < ActiveRecord::Base

  attr_accessor :timestamp
  attr_protected :project_id

  belongs_to :project
  
  has_many :events

  validates_presence_of :title
  validates_presence_of :project_id
  
  after_create  :card_created
  before_update :check_effort_change, :check_started_at_change, :check_finished_at_change
  
  def display_state
    return 'finished'   unless finished_at.nil?
    return 'started'    unless started_at.nil?
    return 'estimated'  unless effort.blank?
    'added'
  end
  
  def started?
    display_state == 'started'
  end
  def finished?
    display_state == 'finished'
  end
  
  private
    def card_created
      Event.card_created(self)
      Event.card_estimated(self, nil, effort) if effort
      true
    end
    
    def check_effort_change
      card_before = Card.find(self.id)
      if card_before.effort != self.effort
        Event.card_estimated(self, card_before.effort, self.effort)
      end
      true
    end
  
    def check_started_at_change
      card_before = Card.find(self.id)
      if self.started_at && card_before.started_at != self.started_at
        Event.card_started(self)
      end
      true
    end
  
    def check_finished_at_change
      card_before = Card.find(self.id)
      if self.finished_at && card_before.finished_at != self.finished_at
        Event.card_finished(self)
      end
      true
    end
  
end
