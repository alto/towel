
set :application, "inlight"
set :repository,  "http://svn.mindmatters.dyndns.org/repos/inlight/platform/trunk/inlight-platform"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :user, 'mongrel'

set :scm_username, 'guest'
set :scm_password, 'guest'
set :rails_env, 'staging'
role :app, "h1361305.stratoserver.net"
role :web, "h1361305.stratoserver.net"
role :db,  "h1361305.stratoserver.net", :primary => true

set :mongrel_conf, "#{shared_path}/config/mongrel_cluster.yml"

# =============================================================================
# RECIPES (overwrite in stages if necessary)
# =============================================================================
require 'lib/cap/backgroundrb_recipes'

after 'deploy:update_code', :set_symlinks

task :set_symlinks do
  run "ln -s #{shared_path}/config/backgroundrb.yml #{release_path}/config/backgroundrb.yml"
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/data #{release_path}/public/data"
end
