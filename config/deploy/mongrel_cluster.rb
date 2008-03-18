Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    namespace :mongrel do
      [ :stop, :start, :restart ].each do |t|
        desc "#{t.to_s.capitalize} the mongrel appserver"
        task t, :roles => :app do
          run "mongrel_rails cluster::#{t.to_s} --clean -C #{mongrel_conf}"
        end
      end
    end  

    desc "Custom restart task for mongrel cluster"
    task :restart do
      deploy.mongrel.restart
    end

    desc "Custom start task for mongrel cluster"
    task :start, :roles => :app do
      deploy.mongrel.start
    end

    desc "Custom stop task for mongrel cluster"
    task :stop, :roles => :app do
      deploy.mongrel.stop
    end

  end
end