ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.resources :contacts, :member => {
    :add_item => :get,
  }
  map.resources :emails, :member => {
    :forward => :get,
    :reply => :get,
    :header => :get,
  }
  map.resource :settings
  map.with_options :controller => 'user_sessions' do |session|
    session.logout 'logout', :action => 'destroy'
    session.login 'login', :action => 'new', :conditions => { :method => :get }
    session.connect 'login', :action => 'create', :conditions => { :method => :post }
  end
  map.mass_process 'mp', :controller => 'emails', :action => 'mass_process', :method => :post
  map.select_mailbox 'select_mailbox', :controller => 'emails', :action => 'select_mailbox'
  map.add_attachment 'add_attachment', :controller => 'emails', :action => 'add_attachment'
  map.inline_attachments 'content/:uid/:cid/:disp', :controller => 'attachments', :action => 'show', :disp => 'inline'
  map.download_attachments 'attachment/:uid/:name/:disp', :controller => 'attachments', :action => 'show', :disp => 'attach'
  map.uploaded_attachments 'uploaded_content/:filename', :controller => 'attachments', :action => 'show_uploaded'
  map.whitelist_uid 'whitelist_uid', :controller => 'emails', :action => 'whitelist_uid'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'emails'
end
