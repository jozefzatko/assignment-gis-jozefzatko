Rails.application.routes.draw do
 
  root  'static_pages#home'

  match '/about_project', to: 'static_pages#about_project', via: 'get'

end
