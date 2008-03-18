#
# Tasks for building 
#

module CruiseCompatibility

# This hack is needed because db:test:purge implementation for MySQL drops the test database, invalidating
 # the existing connection. A solution is to reconnect again.
 def self.reconnect
   require 'active_record'
   configurations = ActiveRecord::Base.configurations
   if configurations and configurations.has_key?("test") and configurations["test"]["adapter"] == 'mysql'
     ActiveRecord::Base.establish_connection(:test)
   end
 end
 
end

task "cruise" do
   ENV['RAILS_ENV'] = 'test'
   if Rake.application.lookup('db:test:purge')
     Rake::Task['db:test:purge'].invoke
   end
   if Rake.application.lookup('db:migrate')   
     CruiseCompatibility::reconnect
     Rake::Task['db:migrate'].invoke
   end
   if Rake.application.lookup('spec')
     Rake::Task['spec'].invoke
   end
end