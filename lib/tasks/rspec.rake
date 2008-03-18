namespace :spec do
  desc 'Run all application-specific specs'
  task :app do
    puts "rspec'ing models"
    Rake::Task["spec:models"].invoke      rescue got_error = true
    puts "rspec'ing controllers"
    Rake::Task["spec:controllers"].invoke rescue got_error = true
    puts "rspec'ing helpers"
    Rake::Task["spec:helpers"].invoke     rescue got_error = true
    puts "rspec'ing views"
    Rake::Task["spec:views"].invoke       rescue got_error = true

    raise "RSpec failures" if got_error
  end  
end
