ActionController::Routing::Routes.draw do |map|

  map.resource  :session

  map.activate          'activate/:activation_code', :controller => 'users', :action => 'activate'
  map.recover_password  '/users/recover_password',   :controller => 'users', :action => 'recover_password'
  map.resources :users
  map.resources :projects do |projects|
    projects.resources :cards
  end
  
  map.admin 'admin', :controller => 'admin', :action => 'index'
  map.namespace :admin do |admin|
    admin.resources :users, :member => {:undelete => :post}
  end

  map.imprint           'imprint',           :controller => 'home', :action => 'imprint'
  map.terms_of_service  'terms_of_service',  :controller => 'home', :action => 'terms_of_service'
  map.contact           'contact',           :controller => 'home', :action => 'contact'
  map.deleted_record    'deleted_record',    :controller => 'home', :action => 'deleted_record'
  map.root :controller => "home"
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
