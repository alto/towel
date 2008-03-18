module ActsAsDeletable
  module ActMethods
    def acts_as_deletable
      include InstanceMethods
    end
  end

  module InstanceMethods
    def delete!
      self.update_attribute(:deleted_at, Time.now)
    end
    def undelete!
      self.update_attribute(:deleted_at, nil)
    end
    def deleted?
      !self.deleted_at.nil?
    end
  end
  
  class RecordDeleted < StandardError; end
  

end

ActiveRecord::Base.extend ActsAsDeletable::ActMethods
