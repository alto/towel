# BackgrounDrb server Capistrano tasks
Capistrano::Configuration.instance(:must_exist).load do
  namespace :backgroundrb do
    desc "Start BackgrounDrb Server"
    task :start, :roles => :web do
      run "cd #{current_path}; script/backgroundrb start"
    end

    desc "Stop BackgrounDrb Server"
    task :stop, :roles => :web do
      run "cd #{current_path}; script/backgroundrb stop; echo 'well done'"
    end

    desc "Restart BackgrounDrb Server"
    task :restart, :roles => :web do
      stop
      start
    end
  
    desc <<-DESC
    Using top to determine the state of the backgroundrb ruby process on the server.
    DESC
    task :sys_info, :roles => :web do
      run "top -b -n 1 | head -7; top -b -n 1 | grep backgroun"
    end    
  end
  
  desc "Restart the backgroundrb server with server restart callback."
  before "deploy:restart", :roles => :web do
    backgroundrb.restart
  end

  desc "Start the backgroundrb server as spinner callback (after mongrel started -> see mongrel_cluster recipes)."
  after "deploy:spinner", :roles => :web do
    backgroundrb.start
  end
end
