# == Schema Information
# Schema version: 9
#
# Table name: projects
#
#  id          :integer(11)     not null, primary key
#  name        :string(255)     
#  description :text            
#  user_id     :integer(11)     
#  url_slug    :string(255)     
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Project < ActiveRecord::Base
  
  attr_protected :user_id
  
  belongs_to :user
  
  has_many :cards
  has_many :events
  
  validates_presence_of :name
  validates_presence_of :user_id

  after_create :project_created

  acts_as_slugable :source_column => :name

  def every_day_project?
    true
  end

  def to_param
    url_slug
  end
  
  private
    def project_created
      Event.project_created(self)
      true
    end

end
